# TASK2-DEMO
Author: Alex Verboonen Cabrera
This repo holds the terraform files which will deploy and destroy infrastructure on GCP
All of the compnents used in this proyect are for educational propurses only, the use of this proyect will be set to be private one its use is over.

As requested. this are the roles required for the Service account that shoud be manager on this taks:


roles/container.admin	Administrador de Kubernetes Engine	
Proporciona acceso a la administración completa de los clústeres y sus objetos de la API de Kubernetes.

Para configurar una cuenta de servicio en los nodos, también debes tener la función de usuario de la cuenta de servicio (roles/iam.serviceAccountUser ) en la cuenta de servicio administrada por el usuario que usarán tus nodos.

Proyecto
roles/container.clusterAdmin	Administrador de clústeres de Kubernetes Engine	
Proporciona acceso a la administración de los clústeres.

Para configurar una cuenta de servicio en los nodos, también debes tener la función de usuario de la cuenta de servicio (roles/iam.serviceAccountUser ) en la cuenta de servicio administrada por el usuario que usarán tus nodos.

Proyecto
roles/container.clusterViewer	Lector de clústeres de Kubernetes Engine	
Proporciona acceso para obtener y enumerar clústeres de GKE.

roles/container.developer	Desarrollador de Kubernetes Engine	
Proporciona acceso a los objetos de la API de Kubernetes dentro de los clústeres.

Proyecto
roles/container.hostServiceAgentUser	Usuario de agente de servicios de host de Kubernetes Engine	
Permite que la cuenta de servicio de Kubernetes Engine en el proyecto host configure los recursos de red compartida de la administración de los clústeres. También brinda acceso para inspeccionar las reglas de firewall del proyecto host.

roles/container.viewer	Visualizador de Kubernetes Engine	
Proporciona acceso de solo lectura a los recursos de clústeres de GKE, como nodos, Pods y objetos de la API de GKE.

Proyecto