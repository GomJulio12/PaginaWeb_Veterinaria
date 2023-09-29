from flask import Flask, render_template,request,url_for, redirect
from flask_mysqldb import MySQL,MySQLdb
import os
from flask_mail import Mail, Message

app = Flask(__name__)
template_dir = os.path.dirname(os.path.abspath(os.path.dirname(__file__)))
template_dir = os.path.join(template_dir, '/templates')

# Inicia 
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'Gomez_2002.' 
app.config['MYSQL_DB'] = 'veterinaria'
mysql = MySQL(app) #Crear una variable

conn = MySQLdb.connect(host=app.config['MYSQL_HOST'],
                       user=app.config['MYSQL_USER'],
                       password=app.config['MYSQL_PASSWORD'],
                       db=app.config['MYSQL_DB'])

#Creando mi primer Decorador o ruta para el Home
@app.route('/', methods=['GET','POST'])
def inicio():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM VW_Cita;")
    data = cur.fetchall() #fetchall () Obtener todos los registros
    cur.close() #cerrando conexion de la BD
    total = cur.rowcount #total de registros
    print(total)
    print (data)
    return render_template('prueba.html', dataVW_Cita = data, dataTotal = total)

#Redireccionando cuando la página no existe
@app.errorhandler(404)
def not_found(error):
        return redirect(url_for('inicio'))

if __name__ == '__main__':
    app.run(debug=True, port=4000)


    

    
