"""\
Manual image builder for local use. "Official" images are built and
pushed by Travis.
"""

import argparse
import io
import os
import subprocess
import sys
import yaml

THIS_DIR = os.path.dirname(os.path.abspath(__file__))
TRAVIS_FN = os.path.join(THIS_DIR, ".travis.yml")


def get_env_settings():
    rval = []
    with io.open(TRAVIS_FN, "rt") as f:
        data = yaml.safe_load(f)
    for d in data["env"]:
        env = dict(_.split("=") for _ in d.split())
        rval.append(env)
    return rval


def build_images(env_list, dry_run=False):
    script = os.path.join(THIS_DIR, "build.sh")
    for env in env_list:
        print(f"* env: {env}")
        if dry_run:
            continue
        subprocess.check_call(f"bash {script}", env=env, shell=True)


def main(args):
    env_list = get_env_settings()
    build_images(env_list, dry_run=args.dry_run)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dry-run", action="store_true",
                        help="show env combos, but don't build anything")
    main(parser.parse_args(sys.argv[1:]))
