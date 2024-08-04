#! /usr/bin/python3
"""Generates OpenSCAD source for a box for an electronics project."""
import argparse
from pathlib import Path

import jinja2

HERE = Path(__file__).parent.resolve()
TEMPLATE_DIR = HERE / '_template'


def generate_file(project_name, template_file_name, template, dest_dir,
                  **options):
    """Generate a single project files from a template."""
    dest_file = dest_dir / template_file_name.replace('PROJECT', project_name)
    env = options.copy()
    env['project'] = project_name
    output_text = template.render(env)
    with open(dest_file, 'w') as outfile:
        outfile.write(output_text)
    if dest_file.name.endswith('.sh'):
        dest_file.chmod(0o775)


def generate_files(project_name, template_dir=None, dest_dir=None, **options):
    """Generate a directory of project files from a template."""
    if dest_dir is None:
        dest_dir = Path(".") / project_name
    if template_dir is None:
        template_dir = TEMPLATE_DIR

    template_loader = jinja2.FileSystemLoader(searchpath=template_dir)
    template_env = jinja2.Environment(loader=template_loader)

    if not dest_dir.exists():
        dest_dir.mkdir()

    for template_file in template_dir.glob('*'):
        name = template_file.name
        if not template_file.is_file():
            continue
        template = template_env.get_template(name)
        generate_file(project_name, name, template, dest_dir,
                      **options)


def main():
    """Command-line interface"""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--project', '-p', help='Name of the project (atom)')

    options = parser.parse_args()
    if options.project:
        project = options.project
    else:
        project = input("Project name: ")

    generate_files(project)


if __name__ == '__main__':
    main()
