JSONB Mapping
=============

Complex mappings are represented by row-level SQL projection functions.

A projection function converts a source row into a canonical JSONB effect
document. The document can be compared for diff generation or passed to a
generic persistence function.

Effect kinds
------------

``update_attribute``
   Updates one canonical attribute.

``enforce_exists``
   Enforces a row exists without overwriting existing attribute values.

``enforce_not_exists``
   Enforces a row does not exist without overwriting existing attribute values.

Example
-------

.. code-block:: json

   {
     "version": 1,
     "source": {
       "model": "agxx",
       "class_id": "GepKnoten",
       "object_id": "ch123456AG987654"
     },
     "effects": [
        {
          "kind": "update_attribute",
          "identity": {
            "class_id": "agxx_wastewater_node",
            "attributes": {
              "fk_wastewater_node": "ch123456AG987654"
            }
          },
          "tww_attribute_id": "ag64_function",
          "value": 1234
        },
        {
          "kind": "enforce_exists",
          "identity": {
            "class_id": "agxx_wastewater_node",
            "attributes": {
              "fk_wastewater_node": "ch123456AG876543"
            }
          }
        },
        {
          "kind": "enforce_not_exists",
          "identity": {
            "class_id": "agxx_wastewater_node",
            "attributes": {
              "fk_wastewater_node": "ch123456AG765432"
            }
          }
        }
     ]
   }
