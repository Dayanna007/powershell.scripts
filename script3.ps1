# script3.ps1
function New-FolderCreation {      #Crea una función llamada New-FolderCreation, que se usará para crear carpetas si no existen.
    [CmdletBinding()]               #Convierte la función en una función avanzada, permitiendo usar características como parámetros obligatorios.
    param(                           #Inicio de la definición de parámetros.
        [Parameter(Mandatory = $true)]    #Define el parámetro $foldername
        [string]$foldername               
    )

    # Create absolute path for the folder relative to current location             #Crear la ruta absoluta de la carpeta
    $logpath = Join-Path -Path (Get-Location).Path -ChildPath $foldername          #una ruta completa segura
    if (-not (Test-Path -Path $logpath)) {                                         #Entra al if solo si la carpeta NO existe
        New-Item -Path $logpath -ItemType Directory -Force | Out-Null              #New-Item crea la carpeta, -Force evita errores si ya existe, Out-Null oculta la salida en consola.
    }                                                                              #Fin del if.

    return $logpath                                                                #Devuelve la ruta completa de la carpeta.
    }                                                                              #Fin de la función New-FolderCreation.
}                                                                                  #Fin de la función New-FolderCreation.

function Write-Log {                                                              #Crear archivos de log y escribir mensajes en logs. 
    [CmdletBinding()]                                                             #Hace la función avanzada.                                                        
    param(
        # Create parameter set                                                     #Parámetros para CREAR archivos
        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]                #Nombre base del archivo
        [Alias('Names')]                                                           #Puede ser uno o varios nombres
        [object]$Name,                    # can be single string or array          #Alias permite usar -Names

        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]                 #Extensión del archivo
        [string]$Ext,                                                               

        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]                #Nombre de la carpeta donde se guardará el archivo
        [string]$folder,

        [Parameter(ParameterSetName = 'Create', Position = 0)]                     #Interruptor (-Create) e Indica que se usará el modo crear archivo
        [switch]$Create,

        # Message parameter set                                                    #Parámetros para ESCRIBIR mensajes
        [Parameter(Mandatory = $true, ParameterSetName = 'Message')]               #Mensaje que se escribirá en el log
        [string]$message,

        [Parameter(Mandatory = $true, ParameterSetName = 'Message')]               #Ruta del archivo donde se escribirá el mensaje
        [string]$path,

        [Parameter(Mandatory = $false, ParameterSetName = 'Message')]               #Nivel del mensaje information, warning y error.
        [ValidateSet('Information','Warning','Error')]
        [string]$Severity = 'Information',

        [Parameter(ParameterSetName = 'Message', Position = 0)]                     #Interruptor para indicar el modo mensaje.
        [switch]$MSG
    )
                                                      #Selección del modo con switch
    switch ($PsCmdlet.ParameterSetName) {             #Detecta qué conjunto de parámetros se usó (Create o Message).
        "Create" {                                    #Crear archivo
            $created = @()                            #Crea un arreglo vacío para guardar rutas creadas

            # Normalize $Name to an array             
            $namesArray = @()
            if ($null -ne $Name) {                                              #Permite usar uno o varios nombres sin errores
                if ($Name -is [System.Array]) { $namesArray = $Name }           
                else { $namesArray = @($Name) }
            } 
                                                                                #Fecha y hora seguras para archivos
            # Date + time formatting (safe for filenames)
            $date1 = (Get-Date -Format "yyyy-MM-dd")
            $time  = (Get-Date -Format "HH-mm-ss")

            # Ensure folder exists and get absolute folder path
            $folderPath = New-FolderCreation -foldername $folder

            foreach ($n in $namesArray) {                       #Recorre cada nombre
                # sanitize name to string
                $baseName = [string]$n

                # Build filename
                $fileName = "${baseName}_${date1}_${time}.$Ext"     #Construye el nombre del archivo.

                # Full path for file
                $fullPath = Join-Path -Path $folderPath -ChildPath $fileName      #Ruta completa del archivo.

                # Create the file (New-Item -Force will create or overwrite; use -ErrorAction Stop to catch errors)
                try {                                                                                                               #Crea el archivo
                    # If you prefer to NOT overwrite existing file, use: if (-not (Test-Path $fullPath)) { New-Item ... }           
                    New-Item -Path $fullPath -ItemType File -Force -ErrorAction Stop | Out-Null

                    # Optionally write a header line (uncomment if desired)
                    # "Log created: $(Get-Date)" | Out-File -FilePath $fullPath -Encoding UTF8 -Append

                    $created += $fullPath                                                                                           #Guarda la ruta creada
                }
                catch {
                    Write-Warning "Failed to create file '$fullPath' - $_"
                }
            }

            return $created
        }
                                                                                  #Modo mensaje                         
        "Message" {          #
            # Ensure directory for message file exists
            $parent = Split-Path -Path $path -Parent                               #Obtiene la carpeta del archivo
            if ($parent -and -not (Test-Path -Path $parent)) {                     
                New-Item -Path $parent -ItemType Directory -Force | Out-Null
            }

            $date = Get-Date
            $concatmessage = "|$date| |$message| |$Severity|"                       #Construir mensaje
                                                                                    #Mostrar en consola con color
            switch ($Severity) {
                "Information" { Write-Host $concatmessage -ForegroundColor Green }
                "Warning"     { Write-Host $concatmessage -ForegroundColor Yellow }
                "Error"       { Write-Host $concatmessage -ForegroundColor Red }
            }

            # Append message to the specified path (creates file if it does not exist)
            Add-Content -Path $path -Value $concatmessage -Force                                   #Guardar en archivo

            return $path
        }

        default {
            throw "Unknown parameter set: $($PsCmdlet.ParameterSetName)"
        }
    }
}

# ---------- Example usage ----------
# This will create the folder "logs" (if missing) and create a file Name-Log_YYYY-MM-DD_HH-mm-ss.log
$logPaths = Write-Log -Name "Name-Log" -folder "logs" -Ext "log" -Create         #Crea la carpeta logs  y crea un archivo 
$logPaths                                                                            #Muestra la ruta del archivo creado.
