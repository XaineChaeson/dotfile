#!/usr/bin/env python
"""
Run an acceptance script and summarize standardized output.

The script should emit lines:
- STEP <n>: <action>
- EXPECTED: <text>
- OBSERVED: <text>
- RESULT: PASS | FAIL
"""
from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path
from typing import List, Dict


def _parse_results(lines: List[str]) -> List[Dict[str, str]]:
    results: List[Dict[str, str]] = []
    current: Dict[str, str] = {}
    for line in lines:
        text = line.strip()
        if text.startswith("STEP "):
            if current:
                results.append(current)
            current = {"step": text}
        elif text.startswith("EXPECTED:"):
            current["expected"] = text[len("EXPECTED:") :].strip()
        elif text.startswith("OBSERVED:"):
            current["observed"] = text[len("OBSERVED:") :].strip()
        elif text.startswith("RESULT:"):
            current["result"] = text[len("RESULT:") :].strip()
    if current:
        results.append(current)
    return results


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--script", required=True, help="Path to acceptance script")
    parser.add_argument("--python", default=sys.executable, help="Python interpreter")
    parser.add_argument("--log-file", help="Path to write full run output")
    args, extra = parser.parse_known_args()

    script_path = Path(args.script)
    if not script_path.exists():
        raise SystemExit(f"Script not found: {script_path}")

    cmd = [args.python, str(script_path), *extra]
    proc = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
    )

    captured: List[str] = []
    log_handle = None
    if args.log_file:
        log_path = Path(args.log_file)
        log_path.parent.mkdir(parents=True, exist_ok=True)
        log_handle = log_path.open("w", encoding="utf-8")
    assert proc.stdout is not None
    for line in proc.stdout:
        print(line, end="")
        if log_handle:
            log_handle.write(line)
        captured.append(line)

    exit_code = proc.wait()
    if log_handle:
        log_handle.flush()
    results = _parse_results(captured)

    total = len(results)
    failed = [item for item in results if item.get("result") != "PASS"]

    print("\n=== Acceptance Summary ===")
    print(f"Total steps: {total}")
    print(f"Failed steps: {len(failed)}")

    for item in failed:
        print(item.get("step", "STEP"))
        print(f"EXPECTED: {item.get('expected', '')}")
        print(f"OBSERVED: {item.get('observed', '')}")
        print(f"RESULT: {item.get('result', '')}")

    if log_handle:
        log_handle.write("\n=== Acceptance Summary ===\n")
        log_handle.write(f"Total steps: {total}\n")
        log_handle.write(f"Failed steps: {len(failed)}\n")
        for item in failed:
            log_handle.write(f"{item.get('step', 'STEP')}\n")
            log_handle.write(f"EXPECTED: {item.get('expected', '')}\n")
            log_handle.write(f"OBSERVED: {item.get('observed', '')}\n")
            log_handle.write(f"RESULT: {item.get('result', '')}\n")
        log_handle.close()

    if exit_code != 0 or failed:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
