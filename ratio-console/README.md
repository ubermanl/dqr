# Ratio Console

Este es un primer approach a la consola web de gestion del ratio escrita en ruby on rails.

# Dependencias Importantes

* Ruby >=2.2
* Rails 4.2.2

# Instalacion
Para poder hacer andar la app

1. Es necesario hacer el git clone del master en este caso
2. Una vez clonado, y situados en el dir de la app hacer un <code>bundle install</code>
3. Copiar el archivo config/database.yml.example a config/database.yml
4. En la consola de mysql crear el usuario para ratio <code>CREATE USER ratio@localhost identified by 'ratio';</code>
5. Grantear los privilegios al usuario <code>GRANT ALL PRIVILEGES on *.* to ratio@localhost;</code>
6. Crear la db, migrar y levantar los datos de prueba <code>rake db:create && rake db:migrate && rake db:seed</code>
7. Ejecutar el server <code>rails s</code>

A partir de esto si todo sale bien, se deberia levantar WeBrick (server de rails) en el puerto 3000 http://localhost:3000 y al acceder redireccionar al login, donde se usa admin/admin
