from .base import Editor


class DamageChannelEditor(Editor):

    class_name = "damage_channel"

    # DISABLED FOR NOW AS PER https://github.com/QGEP/qgepqwat2ili/issues/8
    # this would allow to deselect BCD inspections (start of inspection) by default,
    # as they don't provide valuable information. Once consensus is reached, we
    # can remove this Editor altogether.
    # def initially_checked(self):
    #     """
    #     Determines if the item must be initially checked. To be overriden by subclasses.
    #     """
    #     if self.obj.channel_damage_code__REL.value_en == "BCD":
    #         return False
    #     return True
