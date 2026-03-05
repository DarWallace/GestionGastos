<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    List<String[]> tiendas = (List<String[]>) request.getAttribute("listaTiendas");
    String usuario = (String) session.getAttribute("usuario");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Tiendas</title>
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
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item"><a class="nav-link" href="principal.jsp">Inicio</a></li>
                    <li class="nav-item"><a class="nav-link active" href="servletGestion?op=5">Tiendas</a></li>
                </ul>
                <span class="navbar-text me-3"><i class="bi bi-person-circle"></i> <%= usuario %></span>
                <a href="servletGestion?op=0" class="btn btn-outline-danger btn-sm">Cerrar Sesión</a>
            </div>
        </div>
    </nav>

    <div class="container" style="max-width: 700px;">
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white fw-bold">Añadir Nuevo Establecimiento</div>
            <div class="card-body">
                <form action="servletGestion" method="post" class="row g-3">
                    <input type="hidden" name="op" value="50">
                    <div class="col-8">
                        <input type="text" name="nombreTienda" class="form-control" placeholder="Ej: Mercadona, Gasolinera..." required>
                    </div>
                    <div class="col-4">
                        <button type="submit" class="btn btn-success w-100">
                            <i class="bi bi-plus-circle"></i> Añadir
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <div class="card shadow-sm">
            <div class="card-header bg-white fw-bold text-secondary">Tiendas Registradas</div>
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">Nombre de la Tienda</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(String[] t : tiendas) { %>
                        <tr>
                            <td class="ps-4"><%= t[1] %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        
        <div class="mt-4">
            <a href="servletGestion?op=1" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left"></i> ir a compras
            </a>
        </div>
    </div>

    <script src="./js/alertify.min.js"></script>
    <script>
        <% if("tiendaOK".equals(request.getParameter("res"))) { %>
            alertify.success('Tienda añadida correctamente');
        <% } %>
    </script>
</body>
</html>