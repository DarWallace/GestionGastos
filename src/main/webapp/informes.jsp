<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="es.studium.gestion.*, java.util.*" %>
<%
	List<String[]> listaMeses = (List<String[]>) request.getAttribute("listaMeses");
	List<Compra> compras = (List<Compra>) request.getAttribute("comprasMes");
    Double total = (Double) request.getAttribute("totalMes");
    String mesRef = (String) request.getAttribute("mesActual");
    String usuario = (String) session.getAttribute("usuario");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Informes Mensuales</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="./css/alertify.min.css" />
	<link rel="stylesheet" href="./css/themes/default.min.css" />
    <link rel="stylesheet" href="./css/estilo.css" />
</head>
<body class="body2">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow mb-4">
        <div class="container">
            <a class="navbar-brand" href="principal.jsp"><i class="bi bi-piggy-bank-fill"></i> GASTOS</a>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item"><a class="nav-link active" href="principal.jsp">Inicio</a></li>
                    <li class="nav-item"><a class="nav-link" href="servletGestion?op=5">Tiendas</a></li>
                </ul>
                <span class="navbar-text me-3">
                    <i class="bi bi-person-circle"></i> <%= usuario %>
                </span>
                <a href="servletGestion?op=0" class="btn btn-outline-danger btn-sm">Cerrar Sesión</a>
            </div>
        </div>
    </nav>
    <div class="container mt-4 text-center">
        <h2 class="fw-bold">INFORMES</h2>
        
        <form action="servletGestion" method="post" class="my-4 mx-auto" style="max-width: 300px;">
    	<input type="hidden" name="op" value="6">
	    	<select name="mesFiltro" class="form-select" onchange="this.form.submit()">
	        <% if(listaMeses == null || listaMeses.isEmpty()) { %>
	            <option value="">No hay compras</option>
	        <% } else { 
	            for(String[] m : listaMeses) { %>
	                <option value="<%= m[0] %>" <%= m[0].equals(mesRef) ? "selected" : "" %>>
	                    <%= m[1] %>
	                </option>
	        <% } } %>
	    	</select>
		</form>

        <h3 class="text-uppercase"><%= mesRef %></h3>
        <h4 class="text-success my-3">TOTAL DEL MES: <%= String.format("%.2f", total) %> €</h4>

        <div class="card shadow-sm">
            <table class="table table-bordered align-middle">
                <thead class="table-secondary">
                    <tr>
                        <th>Fecha</th>
                        <th>Tienda</th>
                        <th>Importe</th>
                        <th>Editar</th>
                        <th>Borrar</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(Compra c : compras) { %>
                    <tr>
                        <td><%= c.getFecha() %></td>
                        <td><%= c.getNombreTienda() %></td>
                        <td class="fw-bold"><%= String.format("%.2f", c.getImporte()) %> €</td>
                        <td>
                            <a href="servletGestion?op=2&id=<%= c.getIdCompra() %>" class="btn btn-outline-primary btn-sm me-1" title="Editar">
                        <i class="bi bi-pencil-square"></i>
                    </a>
                        </td>
                        <td>
                            <button onclick="confirmarEliminar(<%= c.getIdCompra() %>)" class="btn btn-outline-danger btn-sm" title="Eliminar">
                        <i class="bi bi-trash"></i>
                    </button>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <div class="mt-4">
            <a href="servletGestion?op=1" class="btn btn-dark">Nueva Compra</a>
            <a href="principal.jsp" class="btn btn-outline-secondary ms-2">Volver</a>
        </div>
    </div>
  <form id="formBorrar" action="servletGestion" method="post" style="display:none;">
    <input type="hidden" name="op" value="3">
    <input type="hidden" name="id" id="idBorrar">
</form>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="./js/alertify.min.js"></script>
<script>
    alertify.set('notifier','position', 'bottom-right');
    
    function confirmarEliminar(id) {
        alertify.confirm("Eliminar Gasto", "¿Seguro que quieres borrar esta compra?",
            function() {
                // Asignamos el ID al input oculto y enviamos el formulario por POST
                document.getElementById('idBorrar').value = id;
                document.getElementById('formBorrar').submit();
            },
            function() {
                alertify.error('Operación cancelada');
            }
        ).set('labels', {ok:'Eliminar', cancel:'Volver'});
    }
</script> 
</body>
</html>