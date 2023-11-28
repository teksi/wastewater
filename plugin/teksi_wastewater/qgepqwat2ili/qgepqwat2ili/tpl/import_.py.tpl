from sqlalchemy.orm import Session
from geoalchemy2.functions import ST_Transform, ST_Force2D

from .. import utils

from .model_{{model_name}} import get_{{model_name}}_model
from .model_{{ilimodel_name}} import get_{{ilimodel_name}}_model


def {{model_name}}_import():

    {{model_name|upper}} = get_{{model_name}}_model()
    {{ilimodel_name|upper}} = get_{{ilimodel_name}}_model()

    {{ilimodel_name}}_session = Session(utils.sqlalchemy.create_engine(), autocommit=False, autoflush=False)
    {{model_name}}_session = Session(utils.sqlalchemy.create_engine(), autocommit=False, autoflush=False)

{% for class_to, classes_from in mapping.items() %}
    print("Importing {{classes_from|qualclassesnames}} -> {{model_name|upper}}.{{class_to.__name__}}")
{% if classes_from|length == 1 %}
    for row in {{ilimodel_name}}_session.query({{classes_from|qualclassesnames}}):
{% else %}
    for row, {{classes_from[1:]|classesnames}} in {{ilimodel_name}}_session.query({{classes_from|qualclassesnames}}){% if classes_from|length > 1 %}.join({{classes_from[1:]|qualclassesnames}}){% endif %}:
{% endif %}

{% for class_from in classes_from %}
{% for src_table, fields in class_from|classfields %}
        # {{src_table}} --- {{fields|join(", ")}}
{% endfor %}

{% endfor %}
        {{class_to.__name__}} = {{model_name|upper}}.{{class_to.__name__}}(
{% for dst_table, fields in class_to|classfields %}
{% if dst_table != '_rel_' and dst_table != '_bwrel_' %}

            # --- {{dst_table}} ---
{% for field in fields %}
            # {{field.name}}=row.REPLACE_ME,  # {{field.property.columns[0].type}}
{% endfor %}
{% endif %}
{% endfor %}
        )
        {{model_name}}_session.add({{class_to.__name__}})
        print(".", end="")
    print("done")

{% endfor %}
    {{model_name}}_session.commit()

    {{model_name}}_session.close()
    {{ilimodel_name}}_session.close()
