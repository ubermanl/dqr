# coding: utf-8

from __future__ import absolute_import

from . import BaseTestCase
from six import BytesIO
from flask import json


class TestAmbienteController(BaseTestCase):
    """ AmbienteController integration test stubs """

    def test_get_estado_sugerido(self):
        """
        Test case for get_estado_sugerido

        Consultar el estado sugerido de un dispositivo Lux
        """
        response = self.client.open('//getEstadoSugerido/{luxId}/{mes}/{diaSemana}/{hora}/{minuto}/{sensLuminosidad}/{sensSonido}/{sensPresencia}'.format(luxId=56, mes=56, diaSemana=56, hora=56, minuto=56, sensLuminosidad=3.4, sensSonido=3.4, sensPresencia=3.4),
                                    method='GET')
        self.assert200(response, "Response body is : " + response.data.decode('utf-8'))


if __name__ == '__main__':
    import unittest
    unittest.main()
