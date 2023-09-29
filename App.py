from flask import Flask, render_template,request,url_for, redirect, session #Libreria Flask Pricipal, sirve para redireccionar rutas y alojar la pagina en un servidor 
from flask_mysqldb import MySQL,MySQLdb #Libreria para la Conexion de la Base de Datos.
from flask_mail import Mail, Message # Libreria para enviar correos ---> pip install Flaks_Mail
import os
from os import path #pip install notify-py
from notifypy import Notify
import pdfkit
import smtplib

app = Flask(__name__)
template_dir = os.path.dirname(os.path.abspath(os.path.dirname(__file__)))
template_dir = os.path.join(template_dir, '/templates')

# ============== Configurar Conexion con la base de datos Mysql ========================
app.config['MYSQL_HOST'] = 'localhost' 
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'Gomez_2002.' #Contraseña de Mysql
app.config['MYSQL_DB'] = 'veterinaria' #Nombre de la Base de Datos
mysql = MySQL(app) #Crear una variable

conn = MySQLdb.connect(host=app.config['MYSQL_HOST'],
                       user=app.config['MYSQL_USER'],
                       password=app.config['MYSQL_PASSWORD'],
                       db=app.config['MYSQL_DB'])

# =======================  Para inicializar el Flask_Mail  ========================
app.config['MAIL_SERVER'] = 'smtp.office365.com' #Servidor para correos de Microsoft (Outlook)
app.config['MAIL_PORT'] = 587 #Puerto por defecto
app.config['MAIL_USE_TLS'] = True #?
app.config['MAIL_USERNAME'] = 'gom_julio12@outlook.com' # El Correo del remitendete (Correo personal )
app.config['MAIL_PASSWORD'] = 'Gomez_2002.OUT' #Contraseña de tu cuenta Outlook
app.config['MAIL_DEFAULT_SENDER'] = 'gom_julio12@outlook.com' #

mail = Mail(app)

# ============== Definir rutas de las Paginas Html ===================
@app.route('/')
def Index():
    return render_template('Index.html')

@app.route('/templates/Index.html')
def Principal():
    return render_template('/Index.html')

@app.route('/templates/home.html')
def Home():
    return render_template('Usuario/home.html')

@app.route('/templates/Especialidades.html')
def Especialidades():
    return render_template('/Especialidades.html')

@app.route('/templates/Servicios.html')
def Servicios():
    return render_template('/Servicios.html')

@app.route('/templates/Quienes Somos.html')
def Contacto():
    return render_template('/Quienes Somos.html')

@app.route('/templates/Login.html')
def Sesion():
    return render_template('/Login.html')

@app.route('/templates/Agendar_Citas.html')
def Agend_Cita():
    return render_template('/Agendar_Citas.html')

#================================  Backed Crud de Pacientes ===========================================
@app.route('/templates/Paciente.html')
def Paciente():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM vw_consulta_paciente;")
    myresult = cur.fetchall()
    #Convertir los datos a diccionario
    insertObject = []
    columnNames = [column[0] for column in cur.description]
    for record in myresult:
        insertObject.append(dict(zip(columnNames, record)))
    cur.close()
    return render_template('Paciente.html', data=insertObject)

#Ruta para guardar pacientes en la base de datos y mostrarlos en la tabla
@app.route('/Agregar_P', methods=['POST'])
def Agregar_Paciente():
    Nombre = request.form['Nombre']
    Especie = request.form['Especie']
    Raza = request.form['Raza']
    F_Nacimiento = request.form['F_Nacimiento']
    Genero = request.form['Genero']
    Peso = request.form['Peso']
    id_Propietario = request.form['id_Propietario']

    if Nombre and Especie and Raza and F_Nacimiento and Raza and Genero and Peso and id_Propietario:
        cur = mysql.connection.cursor()
        sql = "INSERT INTO mascota (id_Propietario, Nombre, Especie, Raza, F_Nacimiento, Genero, Peso) VALUES (%s, %s, %s, %s, %s, %s, %s)"
        data = (id_Propietario, Nombre, Especie, Raza, F_Nacimiento, Genero, Peso)
        cur.execute(sql, data)
        mysql.connection.commit()
    return redirect(url_for('Paciente'))

# Para Eliminar Pacientes
@app.route('/Eliminar/<string:id>')
def Eliminar(id):
    cur = mysql.connection.cursor()
    sql = "DELETE FROM mascota WHERE id_Mascota = %s"
    data = (id,)
    cur.execute(sql, data)
    mysql.connection.commit()
    return redirect(url_for('Paciente'))

# Apartado para Modificar Los datos de los pacientes
@app.route('/Modificar/<string:id_Mascota>', methods=['POST'])
def Modificar(id_Mascota):
    Nombre = request.form['Nombre']
    Especie = request.form['Especie']
    Raza = request.form['Raza']
    F_Nacimiento = request.form['F_Nacimiento']
    Genero = request.form['Genero']
    Peso = request.form['Peso']
    id_Propietario = request.form['id_Propietario']

    if Nombre and Especie and Raza and F_Nacimiento and Raza and Genero and Peso and id_Propietario:
        cur = mysql.connection.cursor()
        sql = "UPDATE mascota SET Nombre = %s, Especie = %s, Raza = %s, F_Nacimiento = %s, Genero = %s, Peso = %s, WHERE id_Mascota = %s"
        data = (Nombre, Especie, Raza, F_Nacimiento, Genero, Peso, id_Mascota)
        cur.execute(sql, data)
        mysql.connection.commit()
    return redirect(url_for('Paciente')) #(home) <--- es la funcion donde retorna al actualizar

# ==================== Inicia parte de las citas ===============================
@app.route('/templates/Citas.html')
def Cita():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM VW_cita;")
    myresult = cur.fetchall()
    #Convertir los datos a diccionario
    insertObject = []
    columnNames = [column[0] for column in cur.description]
    for record in myresult:
        insertObject.append(dict(zip(columnNames, record)))
    cur.close()
    total = cur.rowcount
    print(total)
    return render_template('Citas.html', data=insertObject, dataTotal = total)

#Ruta para guardar Citas en la base de datos y mostrarlos en la tabla
@app.route('/AgendarCita', methods=['POST'])
def Agendar_Cita():
    Nombre = request.form['Nombre']
    Fecha= request.form['Fecha']
    Hora = request.form['Hora']
    Observaciones = request.form['Observaciones']

    if Nombre and Fecha and Hora and Observaciones:
        cur = mysql.connection.cursor()
        sql = "INSERT INTO cita (id_Mascota, fecha, Hora, Observaciones) VALUES (%s, %s, %s, %s)"
        data = (Nombre, Fecha, Hora, Observaciones)
        cur.execute(sql, data)
        mysql.connection.commit()
        enviar_correo()
        
    return redirect(url_for('Cita'))

@app.route('/CitaModificar/<string:id_Cita>', methods=['POST'])
def CitaModificar(id_Cita):
    Fecha = request.form['Fecha']
    Hora = request.form['Hora']
    Observaciones = request.form['Observaciones']
    Mascota= request.form['id_Mascota']

    if Fecha and Hora and Observaciones and Mascota:
        cur = mysql.connection.cursor()
        sql = "UPDATE cita SET Fecha = %s, Hora = %s, Especie = %s, WHERE id_Cita = %s"
        data = (Fecha, Hora, Observaciones, id_Cita)
        cur.execute(sql, data)
        mysql.connection.commit()
    return redirect(url_for('Cita')) #(Cita) <--- es la funcion donde retorna al actualizar

# ****************** METODO PARA ENVIAR CORREO **************************
@app.route('/templates/correo.html')
def enviar_correo():
    msg = Message('Asunto del correo', recipients=['juliogome47@gmail.com'])
    msg.html = render_template('correo.html', nombre='julio')
    mail.send(msg)
    return 'Correo enviado'

# ==================  LOGIN  ==========================
@app.route('/Login', methods= ["GET", "POST"])
def login():

    notificacion = Notify()

    Correo = request.form['Correo']
    Password = request.form['Password']

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM usuario WHERE Correo = %s AND Password = %s", (Correo, Password))
    user = cur.fetchone()
    cur.close()

    if user is not None:
        session['Correo'] = Correo
        session['Nombre'] = user[1]
        session['Apellido1'] = user[2]

        return redirect(url_for('Home'))
    else:
        return render_template('index.html', message="Las credenciales no son correctas")

    #     if len(Usuario)>0:
    #         if Password == Usuario["Password"]:
    #             session['Nombre'] = Usuario['Nombre']
    #             session['Correo'] = Usuario['Correo']
    #             session['Tipo'] = Usuario['Tipo']

    #             if session['Tipo'] == 1:
    #                 return render_template("Administrador/Administrador.html")
    #             elif session['Tipo'] == 2:
    #                 return render_template("Usuario/Home.html")
    #         else:
    #             notificacion.title = "Error de Acceso"
    #             notificacion.message="Correo o contraseña no valida"
    #             notificacion.send()
    #             return render_template("/Login.html")
    #     else:
    #         notificacion.title = "Error de Acceso"
    #         notificacion.message="No existe el usuario"
    #         notificacion.send()
    #         return render_template("/Login.html")
    # else:
    #     return render_template("/Login.html")

#  =================  REGISTRARSE ===================

@app.route('/registrarse', methods=["GET", "POST"])
def register():
    notificacion = Notify()
    if request.method == 'GET':
        return render_template("Login.html")
    else:
        Nombre = request.form['Nombre']
        Apellido1 = request.form['Apellido1']
        Apellido2 = request.form['Apellido2']
        Correo = request.form['Correo']
        Password = request.form['Password']

        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO usuario(Nombre, Apellido1, Apellido2, Correo, Password,Tipo) VALUES (%s,%s,%s,%s,%s,%s)",
                    (Nombre,Apellido1,Apellido2,Correo,Password,2,))
        mysql.connection.commit()
        session['Nombre'] = Nombre
        session['Correo'] = Correo
        notificacion.title = "Registro Exitoso"
        notificacion.send()
        return redirect(url_for("Home"))
   
# @app.route('/generate_pdf/<int:id>', methods=['POST'])
# def generate_pdf(id):
#     paciente = get_paciente_by_id(id)
#     html = render_template('datos_paciente.html', paciente=paciente)
#     pdf = pdfkit.from_string(html, False)
#     response = make_response(pdf)
#     response.headers['Content-Type'] = 'application/pdf'
#     response.headers['Content-Disposition'] = f'inline; filename=paciente_{id}.pdf'

#     return response



   #Cerrar Sesion
@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('Principal'))


if __name__ == '__main__':
    app.secret_key =    "Gomez_2002."
    # app.register_error_handler(401, status_401)
    # app.register_error_handler(404, status_404)
    app.run(debug=True, port=4000, host='0.0.0.0')

    # $ sudo apt-get install libmysqlclient-dev
