<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="es.studium.gestion.*, java.util.*, java.time.*, java.time.format.*" %>
<%
    // 1. Verificación de seguridad: Sesión
    HttpSession sesion = request.getSession();
Integer idUsuario = (Integer) sesion.getAttribute("idUsuario");
String usuario=(String) sesion.getAttribute("usuario");
    if (idUsuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // 2. Inicialización de datos
    Modelo modelo = new Modelo();
    
    List<Compra> listaCompras = modelo.obtenerTodasCompras(idUsuario);
    double totalAcumulado = modelo.calcularTotalHistorico(idUsuario);

    // 3. Lógica para el rango de fechas (Mantenemos esto porque es útil)
    String[] rango = modelo.obtenerRangoFechas();
    String textoRango = "Sin registros";
    
    if (rango[0] != null && rango[1] != null) {
        DateTimeFormatter formatoSalida = DateTimeFormatter.ofPattern("MMMM yyyy", new Locale("es", "ES"));
        LocalDate fechaInicio = LocalDate.parse(rango[0]);
        LocalDate fechaFin = LocalDate.parse(rango[1]);
        textoRango = fechaInicio.format(formatoSalida) + " a " + fechaFin.format(formatoSalida);
        textoRango = textoRango.substring(0, 1).toUpperCase() + textoRango.substring(1);
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Gestión de Gastos - Inicio</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="./css/alertify.min.css" />
    <link rel="stylesheet" href="./css/themes/default.min.css" />
    <link rel="stylesheet" href="./css/estilo.css" />
    <style>
        /* Pequeño ajuste por si no tienes badge-tienda en estilo.css */
        .badge-tienda { background-color: #f0f2f5; color: #333; border: 1px solid #ddd; }
    </style>
</head>
<body class="body2">

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow mb-4">
        <div class="container">
            <a class="navbar-brand" href="principal.jsp"><i class="bi bi-piggy-bank-fill"></i> GASTOS</a>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item"><a class="nav-link active" href="principal.jsp">Inicio</a></li>
                    <li class="nav-item"><a class="nav-link" href="servletGestion?op=5">Tiendas</a></li>
                    <li class="nav-item"><a class="nav-link" href="compras.jsp">Informes</a></li>
                </ul>
                <span class="navbar-text me-3">
                    <i class="bi bi-person-circle"></i> <%= usuario %>
                </span>
                <a href="servletGestion?op=0" class="btn btn-outline-danger btn-sm">Cerrar Sesión</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="row mb-4 align-items-center">
            <div class="col-md-8">
                <h2 class="fw-bold mb-0">Control de Gastos</h2>
                <p class="text-muted fs-5">
                    <i class="bi bi-calendar-range"></i> <%= textoRango %>
                </p>
            </div>
            <div class="col-md-4">
                <div class="card card-total shadow-sm bg-white border-success">
                    <div class="card-body">
                        <h6 class="text-uppercase text-muted small fw-bold">Total Acumulado</h6>
                        <h2 class="mb-0 fw-bold text-success"><%= String.format("%.2f", totalAcumulado) %>€</h2>
                    </div>
                </div>
            </div>
        </div>

        <div class="card shadow-sm">
            <div class="card-header bg-white py-3">
                <h5 class="mb-0 fw-bold text-secondary">Historial Completo de Compras</h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
    <thead class="table-light">
        <tr>
            <th class="ps-4">Fecha</th>
            <th>Tienda / Establecimiento</th>
            <th class="text-end">Importe</th>
            <th class="text-center pe-4">Acciones</th> <%-- Nueva columna --%>
        </tr>
    </thead>
    <tbody>
        <% if(listaCompras.isEmpty()) { %>
            <tr>
                <td colspan="4" class="text-center py-5 text-muted">
                    <i class="bi bi-info-circle fs-4"></i><br>
                    No hay ninguna compra registrada.
                </td>
            </tr>
        <% } else { 
            for(Compra c : listaCompras) { %>
            <tr>
                <td class="ps-4"><%= c.getFecha() %></td>
                <td><span class="badge badge-tienda px-3 py-2 text-dark"><%= c.getNombreTienda() %></span></td>
                <td class="text-end fw-bold text-dark"><%= String.format("%.2f", c.getImporte()) %>€</td>
                <td class="text-center pe-4">
                    <%-- Botón Editar: Envía al controlador con operación 'modificar' --%>
                    <a href="servletGestion?op=2&id=<%= c.getIdCompra() %>" class="btn btn-outline-primary btn-sm me-1" title="Editar">
                        <i class="bi bi-pencil-square"></i>
                    </a>
                    <%-- Botón Eliminar: Usamos una función JavaScript para confirmar --%>
                    <button onclick="confirmarEliminar(<%= c.getIdCompra() %>)" class="btn btn-outline-danger btn-sm" title="Eliminar">
                        <i class="bi bi-trash"></i>
                    </button>
                </td>
            </tr>
        <% } } %>
    </tbody>
</table>
                </div>
            </div>
        </div>
        
        <div class="mt-4 text-end">
            <a href="servletGestion?op=1" class="btn btn-primary shadow-sm">
                <i class="bi bi-plus-lg"></i> Añadir Compra
            </a>
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
        <% if(request.getParameter("login") != null) { // Solo si acaba de entrar %>
            alertify.success('Bienvenido de nuevo, <%= idUsuario %>');
        <% } %>
        <% if("deleted".equals(request.getParameter("res"))) { %>
        alertify.success('Compra eliminada correctamente');
    <% } %>
        
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