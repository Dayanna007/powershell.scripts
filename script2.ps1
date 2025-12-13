Add-Type -AssemblyName System.Windows.Forms  #Carga las librerías de Windows Forms para crear ventanas gráficas. 
Add-Type -AssemblyName System.Drawing   #permite trabajar con tamaños, posiciones y diseño visual.

# Create form   #Crea un formulario
$form = New-Object System.Windows.Forms.Form  #Crea una nueva ventana (formulario).
$form.Text = "Input Form"  #Título que aparece en la barra de la ventana.
$form.Size = New-Object System.Drawing.Size(500,250)    #Define el tamaño de la ventana: 500 px de ancho y 250 px de alto.
$form.StartPosition = "CenterScreen"   #Hace que la ventana se abra centrada en la pantalla.

############# Define labels   #Definir etiquetas labels 
$textLabel1 = New-Object System.Windows.Forms.Label   #Primera etiqueta 
$textLabel1.Text = "Input 1:"
$textLabel1.Left = 20
$textLabel1.Top = 20
$textLabel1.Width = 120

$textLabel2 = New-Object System.Windows.Forms.Label  #Segunda etiqueta
$textLabel2.Text = "Input 2:"
$textLabel2.Left = 20
$textLabel2.Top = 60
$textLabel2.Width = 120

$textLabel3 = New-Object System.Windows.Forms.Label    #Tercera etiqueta 
$textLabel3.Text = "Input 3:"
$textLabel3.Left = 20
$textLabel3.Top = 100
$textLabel3.Width = 120

############# Textbox 1
$textBox1 = New-Object System.Windows.Forms.TextBox
$textBox1.Left = 150
$textBox1.Top = 20
$textBox1.Width = 200

############# Textbox 2
$textBox2 = New-Object System.Windows.Forms.TextBox
$textBox2.Left = 150
$textBox2.Top = 60
$textBox2.Width = 200

############# Textbox 3
$textBox3 = New-Object System.Windows.Forms.TextBox
$textBox3.Left = 150
$textBox3.Top = 100
$textBox3.Width = 200

############# Default values
$defaultValue = ""
$textBox1.Text = $defaultValue
$textBox2.Text = $defaultValue
$textBox3.Text = $defaultValue

############# OK Button
$button = New-Object System.Windows.Forms.Button   #Crea un botón
$button.Left = 360
$button.Top = 140                   #Define posición y tamaño del botón
$button.Width = 100
$button.Text = "OK"                 #Texto que aparece en el botón.

############# Button click event       #Evento al hacer clic en el botón
$button.Add_Click({                     #Define lo que sucede cuando se hace clic en OK.
    $form.Tag = @{                      #Tag funciona como un contenedor para datos temporales.
        Box1 = $textBox1.Text           
        Box2 = $textBox2.Text
        Box3 = $textBox3.Text
    }
    $form.Close()                   #Cierra la ventana después de guardar los datos.
})

############# Add controls               #Agrega controles a los formularios
$form.Controls.Add($button)              #Añade todos los elementos (labels, textboxes y botón) al formulario.
$form.Controls.Add($textLabel1)
$form.Controls.Add($textLabel2)
$form.Controls.Add($textLabel3)
$form.Controls.Add($textBox1)
$form.Controls.Add($textBox2)
$form.Controls.Add($textBox3)

############# Show dialog                #Mostrar el formulario
$form.ShowDialog() | Out-Null            #Out-Null evita que se muestre información innecesaria en la consola.

############# Return values               #Devolver los valores ingresados
return $form.Tag.Box1, $form.Tag.Box2, $form.Tag.Box3     #Devuelve los valores escritos por el usuario en las tres cajas de texto y Se pueden capturar en variables cuando se llama al script.
