function Start-ProgressBar {   #Declara (crea) una nueva función llamada Start-ProgressBar.
    [CmdletBinding()]   #permitiendo usar características de cmdlets (como validaciones, parámetros, etc..)
    param (   #Comienza la sección donde se definen los parámetros que la función recibirá.
        [Parameter (Mandatory = $true)]  #Indica que el parámetro siguiente es obligatorio.
        $Title,  #Define el parámetro $Title, que contendrá el texto que se mostrará en la barra de progreso.
        
        [Parameter (Mandatory = $true)] #parámetro también es obligatorio.
        [int]$Timer #antidad de segundos que durará la barra.
    )

    For ($i = 1; $i -le $Timer; $i++) {  #$i = 1 → el contador empieza en 1 #$i -le $Timer → el bucle continúa mientras $i sea menor o igual al tiempo total #$i++ → en cada vuelta, $i aumenta en 1
        Start-Sleep -Seconds 1  #Pausa la ejecución durante 1 segundo, esto hace que la barra avance real tiempo.
        $percentComplete = ($i/ $Timer) * 100 #Calcula el porcentaje completado.
        Write-Progress -Activity $Title -Status "$i seconds elapsed" -PercentComplete $percentComplete  #Muestra la barra de progreso en PowerShell como tambien muestra cuántos segundos han pasado y dibuja la barra con ese porcentaje
    }
} 
Start-ProgressBar -Title "Test timeout" -Timer 30  #estás ejecutando la función llamada Start-ProgressBar.
