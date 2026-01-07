#!/usr/bin/env python
"""
Acceptance test template.
Fill in config loading, setup, and step execution logic.
"""
from __future__ import annotations

import os
import sys
import argparse
import json
from pathlib import Path
from typing import Dict

CONFIG_SAMPLE = {
    "ENV_NAME": "staging",
    "BASE_URL": "https://example.test",
    "RPC_URL": "https://rpc.example.test",
    "API_TOKEN": "<token>",
    "USERNAME": "<user>",
    "PASSWORD": "<password>",
}


def _load_config(path: str) -> Dict[str, str]:
    cfg_path = Path(path)
    if not cfg_path.exists():
        return {}
    return json.loads(cfg_path.read_text(encoding="utf-8"))


def _build_config(path: str) -> Dict[str, str]:
    cfg = _load_config(path)
    # Extend with project-specific keys as needed.
    return {
        "config_path": str(Path(path)),
        "env_name": os.getenv("ENV_NAME", cfg.get("ENV_NAME", "")),
        "base_url": os.getenv("BASE_URL", cfg.get("BASE_URL", "")),
        "rpc_url": os.getenv("RPC_URL", cfg.get("RPC_URL", "")),
    }


# Fill with project-specific keys (e.g. API_BASE_URL, USERNAME, TOKEN).
CONFIG: Dict[str, str] = {}


def _env_snapshot() -> None:
    print("ENV SNAPSHOT")
    if CONFIG.get("config_path"):
        print(f"CONFIG_PATH={CONFIG['config_path']}")
    if CONFIG.get("env_name"):
        print(f"ENV_NAME={CONFIG['env_name']}")
    if CONFIG.get("base_url"):
        print(f"BASE_URL={CONFIG['base_url']}")
    if CONFIG.get("rpc_url"):
        print(f"RPC_URL={CONFIG['rpc_url']}")


def _log_step(step_no: int, action: str, expected: str, observed: str, result: str) -> None:
    print(f"STEP {step_no}: {action}")
    print(f"EXPECTED: {expected}")
    print(f"OBSERVED: {observed}")
    print(f"RESULT: {result}")


def _execute_step(step: Dict[str, str]) -> str:
    # TODO: Implement user-perspective verification for this step.
    # Use CONFIG for project-specific parameters.
    raise NotImplementedError("Implement step logic")


def _cleanup() -> None:
    # TODO: Remove local temp files or close sessions if applicable.
    pass


def run() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", default="config.json", help="Config JSON path")
    args = parser.parse_args()
    global CONFIG
    CONFIG = _build_config(args.config)
    dry_run = os.getenv("DRY_RUN", "0") == "1"
    _env_snapshot()
    steps = [
        {"action": "<action>", "expected": "<expected>", "notes": "<notes>"},
    ]

    for idx, step in enumerate(steps, start=1):
        action = step.get("action", "")
        expected = step.get("expected", "")
        if dry_run:
            observed = "dry run"
            result = "PASS"
        else:
            observed = _execute_step(step)
            result = "PASS" if observed else "FAIL"
        _log_step(idx, action, expected, observed, result)
        if result != "PASS":
            _cleanup()
            return 1
    _cleanup()
    return 0


if __name__ == "__main__":
    sys.exit(run())
