# Ratio Console

Este es un primer approach a la consola web de gestion del ratio escrita en ruby on rails.

# Dependencias Importantes

* Ruby >=2.3
* Rails 4.2.5
* MySql 5.5+

# Instalacion

* Ruby

`rvm install 2.3`

* Rails

`gem install rails -v 4.2.5 --no-ri --no-rdoc`

1. Es necesario hacer el git clone del master en este caso
2. Una vez clonado, y situados en el dir de la app hacer un `bundle install`
3. Copiar el archivo config/database.yml.example a config/database.yml
4. En la consola de mysql crear el usuario para ratio `CREATE USER ratio_dev@localhost identified by 'ratio_dev_123';`
5. Grantear los privilegios al usuario `GRANT ALL PRIVILEGES on *.* to ratio_dev@localhost;`
6. Crear la db, migrar y levantar los datos de prueba `rake db:create && rake db:migrate && rake db:seed`
7. Ejecutar el server `rails s`

A partir de esto si todo sale bien, se deberia levantar WeBrick (server de rails) en http://localhost:3000 y al acceder redireccionar al login, donde se usa admin/admin

# Stored Procedures
* Para registrar un evento `select generate_event(module_id,module_status)` que devuelve un INT con el id de evento generado.
* Para registrar datos de sensores de un evento `call generate_event_data(module_id,sensor_type_id,value)` no devuelve valores ya que es un SP
