###################################  #Línea de separación y un comentario que indica que lo siguiente son prerrequisitos.
# Prerequisites

# Update the list of packages  #actualizará la lista de paquetes.
sudo apt-get update    #descarga información actualizada de los paquetes.

# Install pre-requisite packages.  #indica que ahora se instalarán paquetes necesarios.
sudo apt-get install -y wget apt-transport-https software-properties-common   #Instala tres paquetes necesarios ( wget apt-transport-https software-properties-common)

# Get the version of Ubuntu  #se obtendrá la versión de Ubuntu para usarla luego
source /etc/os-release    #Carga en memoria (en variables) la información de la versión del sistema.

# Download the Microsoft repository keys     #explica que se descargará el archivo con la clave del repositorio de Microsoft.
wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb    #contiene las claves y configuración del repositorio de Microsoft, adaptado a la versión de Ubuntu

# Register the Microsoft repository keys   #indica que se va a instalar/registrar la clave descargada.
sudo dpkg -i packages-microsoft-prod.deb   #Usa dpkg para instalar el archivo .deb descargado

# Delete the Microsoft repository keys file    #explica que se eliminará el archivo .deb porque ya no se necesita.
rm packages-microsoft-prod.deb   #Elimina el archivo .deb descargado, ya que ya está instalado.

# Update the list of packages after we added packages.microsoft.com  #por probar  #ahora que se añadió un nuevo repositorio, volveremos a actualizar la lista de paquetes.
sudo apt-get update  #Actualiza nuevamente la lista de paquetes, pero ahora también incluye los paquetes de Microsoft
