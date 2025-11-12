#!/usr/bin/env python3
"""Create a default RebeccaHQ agent if none exists.

Usage: from the repo root with the virtualenv active and environment configured:
  python3 scripts/initialize_agent.py
"""
import sys
import os

# Ensure the repo root is on PYTHONPATH so this script can be run from scripts/ directly
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from superagi.controllers.agent_controller import AgentController


def create_default_agent():
    name = os.getenv("MASTER_AGENT_NAME", "RebeccaHQ")
    controller = AgentController()
    try:
        existing = controller.get_agent_by_name(name)
        if existing:
            print(f"✅ Agent '{name}' already exists.")
            return
        controller.create_agent({
            "name": name,
            "description": "Autonomous operations and Google integration agent",
            "model": "gpt-4",
            "goal": "Assist with full business workflow automation.",
            "instruction": "Coordinate all sub-agents for ISHE, EventSafe, and logistics.",
            "voice_enabled": os.getenv("ENABLE_SPEECH", "False") == "True",
            "language": os.getenv("DEFAULT_LANGUAGE", "en-GB"),
        })
        print(f"🎯 Created new agent: {name}")
    except Exception as e:
        print(f"⚠️ Could not initialize agent: {e}")


if __name__ == "__main__":
    create_default_agent()
