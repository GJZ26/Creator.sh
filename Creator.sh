#!/bin/bash

clear

# --- # Instrucciones # --- #

echo -e "Bienvenido a Creator.sh v2.0.0 \n
Recuerda lo siguiente antes de empezar:
- Usar una sola palabra para su paquete
- Escribir el paquete en singular
- No usar carácteres especiales y/o números
- Estar ubicado en la misma carpeta de tu función main \n"

# --- # BAUTIZO DE CARPETAS # --- #
echo -e "Ingrese el nombre de su paquete: \c"
read project
project=$(echo "$project" | tr '[:upper:]' '[:lower:]')
entity=${project^}


# --- # MANEJADORES DE PAQUETE # --- #
IFS='/'
javaIndex=0
projectPackages=

# Mete a un array los directorios
echo -e '\nLeyendo ruta actual...'
read -a dirList <<<$(pwd)
directoriesLength=`expr ${#dirList[@]} - 1`

# Verifica si está la carpeta java
echo "Verificando proyecto..."
for index in "${!dirList[@]}"
do

    if [[ "${dirList[index]}" =~ "java" ]]
    then
        javaIndex=`expr $index + 1`
        projectPackages="${dirList[javaIndex]}"
        javaIndex=`expr $index + 2`
        break
    fi

    if [[ "$index" =~ "$directoriesLength" ]]
    then
        echo "No se ha podido encontrar el directorio Java"
        exit
    fi

done

# Creando ruta de paquete
while [ $javaIndex -le $directoriesLength ]
do
    projectPackages="$projectPackages.${dirList[javaIndex]}"
    ((javaIndex++))
done

# --- # CREANDO ARCHIVOS # --- #

echo -e "\nCreando carpeta para ${project}"
mkdir $project

echo -e "\nCreando carpeta Controller"
mkdir $project/controllers
cd $project/controllers

echo -e "Creando archivo ${entity}Controller.java"
cat <<EOF > ${entity}Controller.java
package ${projectPackages}.${project}.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ${projectPackages}.${project}.services.interfaces.I${entity}Service;

@RestController
@RequestMapping("${project}")
public class ${entity}Controller {

    @Autowired
    I${entity}Service service;

    // Por Hacer:
    // - Agregar las rutas correspondientes para las peticiones HTTP
    //     - GET, POST, UPDATE y DELETE

    // La interfaz del servicio ya están importados

    // Si accedes a localhost:8080/${project} podrás ver el mensaje
    @GetMapping
    public String HelloWorld() {
        return "Hello World, we're in ${entity}";
    }

}
EOF
cd -

echo -e "\nCreando DTOS"
mkdir $project/controllers/dtos
mkdir $project/controllers/dtos/responses
cd $project/controllers/dtos/responses

echo "Creando archivo Get${entity}Response.java"
cat <<EOF > Get${entity}Response.java
package ${projectPackages}.${project}.controllers.dtos.responses;

import lombok.Getter;
import lombok.Setter;

@Setter @Getter
public class Get${entity}Response {

    // Por Hacer: 
    // - Agregar atributos necesarios
    
    // Este DTO servirá para devolver la información necesaria
    // de alguna petición GET para la entidad ${entity}

    // Id debe ser obligtorio dentro de los response para fines demostrativos
    
    // No hace falta agregar Setters y Getters

    private Long id;

}
EOF
cd -

mkdir $project/controllers/dtos/requests
cd $project/controllers/dtos/requests

echo "Creando archivo Post${entity}Request.java"
cat <<EOF > Post${entity}Request.java
package ${projectPackages}.${project}.controllers.dtos.requests;

import lombok.Getter;
import lombok.Setter;

@Setter @Getter
public class Post${entity}Request {
    // Por Hacer:
    // - Agregar los atributos para este DTO

    // No es necesario agregar los métodos setter y getter para este método.

    // Este DTO es para mandar información para crear un nuevo registro
    // de la entidad ${entity} en la base de datos

    // Generar los DTOS necesarios para lo demás métodos si lo consideran necesario
}
EOF
cd -

echo -e "\nCreando Servicios"
mkdir $project/services
cd $project/services

echo "Creando archivo ${entity}ServiceImpl.java"
cat <<EOF > ${entity}ServiceImpl.java
package ${projectPackages}.${project}.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ${projectPackages}.${project}.repositories.I${entity}Repository;
import ${projectPackages}.${project}.services.interfaces.I${entity}Service;

@Service
public class ${entity}ServiceImpl implements I${entity}Service{

    @Autowired
    I${entity}Repository repository;

    // Por Hacer:
    // - Generar métodos en I${entity}Service y sobre escribir acá

    // Los métodos del repositorio ya están siendo importados
    // repository.metodo()
    
}
EOF
cd -

echo -e "\nCreando Interfaces de Servicios"
mkdir $project/services/interfaces
cd $project/services/interfaces

echo "Creando archivo I${entity}Service.java"
cat <<EOF > I${entity}Service.java
package ${projectPackages}.${project}.services.interfaces;

public interface I${entity}Service {
    // Por Hacer:
    // - Genera las interfaces de lo métodos para los servicios

    // Recuerda que mínimo deberán haber 4 métodos (del protocolo HTTP)
}
EOF
cd -

echo -e "\nCreando Repositorio"
mkdir $project/repositories
cd $project/repositories

echo "Creando archivo I${entity}Repository.java"
cat <<EOF > I${entity}Repository.java
package ${projectPackages}.${project}.repositories;

import org.springframework.stereotype.Repository;
import ${projectPackages}.${project}.entities.${entity};
import org.springframework.data.jpa.repository.JpaRepository;

// No es necesario ninguna acción acá

@Repository
public interface I${entity}Repository extends JpaRepository<${entity}, Long>{}
EOF
cd -

echo -e "\nCreando Entidad"
mkdir $project/entities
cd $project/entities

echo "Creando archivo ${entity}.java"
cat <<EOF > ${entity}.java 
package ${projectPackages}.${project}.entities;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "${project}s")
@Setter @Getter
public class ${entity} {

    // Por Hacer:
    // - Verifica que el nombre de la tabla esté generado correctamente
    // - Añade los atributos necesarios, recuerda que debe ser en inglés

    // No hace falta generar Getter y Setter

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

}
EOF
cd -

echo -e "\nScript finalizado"