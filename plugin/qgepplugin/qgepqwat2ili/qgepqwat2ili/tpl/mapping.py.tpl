from .{{model_name}} import Classes as {{model_name|upper}}
from .{{ilimodel_name}} import Classes as {{ilimodel_name|upper}}

{{model_name|upper}}_TO_{{ilimodel_name|upper}} = {
    # ALREADY MAPPED
{% for class_from, classes_to in mapping.items() %}
    {{model_name|upper}}.{{class_from.__name__}}: [{{classes_to|qualclassesnames}}],
{% endfor %}

    # AVAILABLE TABLES
    # {{ILIMODEL|sort(attribute='__name__')|qualclassesnames}}

    # NOT YET MAPPED
{% for class_from in MODEL|sort(attribute='__name__') %}
{% if class_from not in mapping.keys() %}
    # {{model_name|upper}}.{{class_from.__name__}}: [{{ilimodel_name|upper}}.REPLACE_ME],
{% endif %}
{% endfor %}
}
