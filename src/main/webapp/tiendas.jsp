<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, es.studium.gestion.Tienda" %>
<%
    List<Tienda> tiendas = (List<Tienda>) request.getAttribute("listaTiendas");
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
                    <li class="nav-item"><a class="nav-link" href="servletGestion?op=6">Informes</a></li>
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
                            <th class="text-center">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if(tiendas != null) { 
                            for(Tienda t : tiendas) { %>
                        <tr>
                            <td class="ps-4 align-middle"><%= t.getNombreTienda() %></td>
                            <td class="text-center">
                                <button class="btn btn-outline-primary btn-sm me-1" 
                                        onclick="abrirModalEditar(<%= t.getIdTienda() %>, '<%= t.getNombreTienda() %>')">
                                    <i class="bi bi-pencil-square"></i>
                                </button>
                                <button class="btn btn-outline-danger btn-sm" 
                                        onclick="confirmarBorrarTienda(<%= t.getIdTienda() %>)">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="mt-4">
            <a href="principal.jsp" class="btn btn-outline-secondary"><i class="bi bi-arrow-left"></i> Volver</a>
        </div>
    </div>

    <div class="modal fade" id="modalEditarTienda" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="servletGestion" method="post">
                    <input type="hidden" name="op" value="51">
                    <input type="hidden" name="idTiendaEdit" id="idTiendaEdit">
                    <div class="modal-header">
                        <h5 class="modal-title">Editar Establecimiento</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <label class="form-label">Nombre de la tienda:</label>
                        <input type="text" name="nombreTiendaEdit" id="nombreTiendaEdit" class="form-control" required>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary">Guardar Cambios</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <form id="formBorrarTienda" action="servletGestion" method="post" style="display:none;">
        <input type="hidden" name="op" value="52">
        <input type="hidden" name="id" id="idBorrarTienda">
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="./js/alertify.min.js"></script>
    <script>
        function abrirModalEditar(id, nombre) {
            document.getElementById('idTiendaEdit').value = id;
            document.getElementById('nombreTiendaEdit').value = nombre;
            var myModal = new bootstrap.Modal(document.getElementById('modalEditarTienda'));
            myModal.show();
        }

        function confirmarBorrarTienda(id) {
            alertify.confirm("Eliminar Tienda", "¿Seguro? Si tiene compras asociadas no se podrá borrar.",
                function() {
                    document.getElementById('idBorrarTienda').value = id;
                    document.getElementById('formBorrarTienda').submit();
                }, null).set('labels', {ok:'Eliminar', cancel:'Cancelar'});
        }

        <% String res = request.getParameter("res"); 
           if("tiendaOK".equals(res)) { %> alertify.success('Tienda añadida correctamente'); <% } 
           if("tiendaEditOK".equals(res)) { %> alertify.success('Tienda actualizada'); <% } 
           if("errorBorrado".equals(res)) { %> alertify.error("No se puede eliminar: Esta tienda está en uso."); <% } 
           if("tiendaBorradaOK".equals(res)) { %> alertify.success("Tienda eliminada."); <% } %>
    </script>
</body>
</html>