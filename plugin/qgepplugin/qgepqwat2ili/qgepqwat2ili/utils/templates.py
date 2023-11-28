import collections
import os

from jinja2 import Environment, FileSystemLoader
from sqlalchemy.orm.attributes import InstrumentedAttribute


def generate_template(model_name, ilimodel_name, model_base, ilimodel_base, mapping):
    def filter_classfields(cls):
        """Jinja filter used in the template"""
        available_fields = collections.defaultdict(list)
        for attr_name, attr in list(cls.__dict__.items()):
            # if attr_name.startswith('__'):
            #     continue
            if not isinstance(attr, InstrumentedAttribute):
                continue
            if not hasattr(attr.property, "columns"):
                key = "_rel_" if attr_name.endswith("__REL") else "_bwrel_"
            else:
                key = attr.property.columns[0].table.name
            available_fields[key].append(attr)
        for fields in available_fields.values():
            fields.sort(key=lambda i: str(i))
        ordered_tables = ["_rel_", "_bwrel_"] + list(c.__table__.name for c in cls.__mro__ if hasattr(c, "__table__"))
        return sorted(
            available_fields.items(),
            key=lambda i: ordered_tables.index(i[0]),
            reverse=True,
        )

    def filter_classesnames(classes):
        """Jinja filter used in the template"""
        return ", ".join(c.__name__ for c in classes)

    def filter_qualclassesnames(classes):
        """Jinja filter used in the template"""
        return ", ".join(f"{ilimodel_name.upper()}.{c.__name__}" for c in classes)

    tpl_folder = os.path.join(os.path.dirname(__file__), "..", "tpl")
    env = Environment(loader=FileSystemLoader(tpl_folder), lstrip_blocks=True, trim_blocks=True)
    env.filters["classfields"] = filter_classfields
    env.filters["classesnames"] = filter_classesnames
    env.filters["qualclassesnames"] = filter_qualclassesnames

    variables = {
        "mapping": mapping,
        "MODEL": model_base.classes,
        "ILIMODEL": ilimodel_base.classes,
        "model_name": model_name,
        "ilimodel_name": ilimodel_name,
    }

    # Generate code stub for the import script
    template = env.get_template("import_.py.tpl")
    result = template.render(variables)
    path = os.path.join(os.path.dirname(__file__), "..", model_name, "import_.py.tpl")
    open(path, "w", newline="\n").write(result)

    # Generate code stub for the export script
    template = env.get_template("export.py.tpl")
    result = template.render(variables)
    path = os.path.join(os.path.dirname(__file__), "..", model_name, "export.py.tpl")
    open(path, "w", newline="\n").write(result)

    # Generate code stub for the mapping script
    template = env.get_template("mapping.py.tpl")
    result = template.render(variables)
    path = os.path.join(os.path.dirname(__file__), "..", model_name, "mapping.py.tpl")
    open(path, "w", newline="\n").write(result)

    # Generate code stubs for the models using sqlacodegen
    # Disabled for now but could be useful at some point
    # see https://github.com/agronholm/sqlacodegen/issues/128 for this to be useful
    # from sqlacodegen.codegen import CodeGenerator
    # path = os.path.join(os.path.dirname(__file__), "..", model_name, f"model_{model_name}.py.tpl")
    # model_base.metadata.bind(create_engine())
    # generator = CodeGenerator(model_base.metadata)
    # generator.render(open(path, 'w+', encoding='utf-8'))
    print("NOTICE: sqlacodegen template is disabled for now")
