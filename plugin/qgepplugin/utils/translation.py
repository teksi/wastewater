"""
This module is used for translation of the QGEP project
"""
import logging
import os
from builtins import str

from qgis.PyQt.QtCore import (
    QCoreApplication,
    QLocale,
    QObject,
    QSettings,
    QTranslator,
    pyqtSlot,
)
from qgis.PyQt.QtWidgets import QApplication


def setup_i18n(the_preferred_locale=None):
    """
    Setup internationalisation for the plugin.

    See if QGIS wants to override the system locale
    and then see if we can get a valid translation file
    for whatever locale is effectively being used.

    @param the_preferred_locale will override any other locale setting
    """

    logger = logging.getLogger(__name__)

    my_override_flag = QSettings().value("locale/overrideFlag", False, type=bool)

    my_locale_name = None
    if the_preferred_locale is not None:
        my_locale_name = the_preferred_locale
        logger.info("Using preferred locale: " + my_locale_name)
    elif my_override_flag:
        my_locale_name = QSettings().value("locale/userLocale", "")
        logger.info("Using QGIS override locale: " + my_locale_name)
    else:
        my_locale_name = QLocale.system().name()
        # NOTES: we split the locale name because we need the first two
        # character i.e. 'id', 'af, etc
        my_locale_name = str(my_locale_name)
        logger.info("Using system default locale: " + my_locale_name)

    # Insert into QT's translation system
    # As soon as translator gets deleted, the translation will stop
    # Therefore, QCoreApplication is set as parent to not delete it
    # while the application is running (but we might end up loading
    # the same translation twice)
    translator = QTranslator(QCoreApplication.instance())

    my_translator_file = "qgepplugin_" + my_locale_name
    my_translator_path = os.path.join(
        os.path.dirname(os.path.dirname(__file__)), "i18n", my_translator_file
    )

    my_result = translator.load(my_translator_path)

    if my_result:
        QCoreApplication.instance().installTranslator(translator)


# pylint: disable=too-few-public-methods
class QgepJsTranslator(QObject):
    """
    Provides a callback method for the javascript code to support translation
    """

    def __init__(self):
        QObject.__init__(self)

    # pylint: disable=R0201
    @pyqtSlot(str, str, name="qsTr", result=str)
    def qsTr(self, context, source_text):
        """
        Will be called by javascript code to perform translation of strings
        :param context:    The translation context
        :param source_text: The string to translate
        :return:
        """
        return QApplication.translate(context, source_text)
