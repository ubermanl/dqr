## Archivos de sistema de DqR Master

Este directorio contiene archivos de sistema para manejar los servicios de DqR que sean necesarios. La estructura de directorios representa la ubicación final de los archivos una vez instalados.

### Archivo de configuración de rsyslog
Permite que adicionalmente al journal, los logs se guarden en un directorio aparte, para facilitar la revisión.

    sudo cp {,/}etc/rsyslog.d/dqrMaster.conf
    sudo systemctl restart rsyslog
    tail -f /var/log/dqr/dqrMaster.log


### Archivo de rotación de logs
Permite rotar los logs que se creen en el paso anterior.

    sudo cp {,/}etc/logrotate.d/dqr
    

### Archivo de unidad de systemd para dqrMaster y ratioConsole
Permite habilitar el servicio para que inicie automáticamente con el sistema. Para instalar e inciar el servicio:

    sudo cp etc/systemd/system/* /etc/systemd/system
    sudo cp {,/}etc/init.d/ratioConsole
    sudo systemctl daemon-reload
    sudo systemctl enable dqrMaster.service
    sudo systemctl start dqrMaster.service
    sudo systemctl enable ratioConsole.service
    sudo systemctl start ratioConsole.service


