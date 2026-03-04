<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="es.studium.gestion.*, java.util.*, java.time.*, java.time.format.*" %>
<%
    // 1. Verificación de seguridad: Sesión
    HttpSession sesion = request.getSession();
    String usuario = (String) sesion.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // 2. Inicialización de datos
    Modelo modelo = new Modelo();
    LocalDate hoy = LocalDate.now();
    
    // Lista de compras del mes actual y total
    List<Compra> comprasMes = modelo.obtenerComprasMes(hoy.getMonthValue(), hoy.getYear());
    double totalMes = modelo.calcularTotalMes(hoy.getMonthValue(), hoy.getYear());

    // 3. Lógica para el rango de fechas (De primera compra a última)
    String[] rango = modelo.obtenerRangoFechas();
    String textoRango = "Sin registros";
    
    if (rango[0] != null && rango[1] != null) {
        // Formateador para "Mes Año" en español
        DateTimeFormatter formatoSalida = DateTimeFormatter.ofPattern("MMMM yyyy", new Locale("es", "ES"));
        
        LocalDate fechaInicio = LocalDate.parse(rango[0]);
        LocalDate fechaFin = LocalDate.parse(rango[1]);
        
        textoRango = fechaInicio.format(formatoSalida) + " a " + fechaFin.format(formatoSalida);
        // Poner la primera letra en mayúscula
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
    <style>
        body { background-color: #f8f9fa; }
        .navbar-brand { font-weight: bold; color: #198754 !important; }
        .card-total { border-left: 5px solid #198754; }
        .badge-tienda { background-color: #e9ecef; color: #495057; border: 1px solid #dee2e6; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow mb-4">
        <div class="container">
            <a class="navbar-brand" href="principal.jsp"><i class="bi bi-piggy-bank-fill"></i> GASTOS</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item"><a class="nav-link active" href="principal.jsp">Inicio</a></li>
                    <li class="nav-item"><a class="nav-link" href="tiendas.jsp">Tiendas</a></li>
                    <li class="nav-item"><a class="nav-link" href="compras.jsp">Compras</a></li>
                </ul>
                <span class="navbar-text me-3">
                    <i class="bi bi-person-circle"></i> <%= usuario %>
                </span>
                <a href="logout.jsp" class="btn btn-outline-danger btn-sm">Cerrar Sesión</a>
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
                <div class="card card-total shadow-sm bg-white">
                    <div class="card-body">
                        <h6 class="text-uppercase text-muted small fw-bold">Gastos de este mes</h6>
                        <h2 class="mb-0 fw-bold text-success"><%= String.format("%.2f", totalMes) %>€</h2>
                    </div>
                </div>
            </div>
        </div>

        <div class="card shadow-sm">
            <div class="card-header bg-white py-3">
                <h5 class="mb-0 fw-bold text-secondary">Compras registradas recientemente</h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4">Fecha</th>
                                <th>Tienda / Establecimiento</th>
                                <th class="text-end pe-4">Importe</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if(comprasMes.isEmpty()) { %>
                                <tr>
                                    <td colspan="3" class="text-center py-5 text-muted">
                                        <i class="bi bi-info-circle fs-4"></i><br>
                                        No se han encontrado compras en el mes de <%= hoy.format(DateTimeFormatter.ofPattern("MMMM", new Locale("es","ES"))) %>.
                                    </td>
                                </tr>
                            <% } else { 
                                for(Compra c : comprasMes) { %>
                                <tr>
                                    <td class="ps-4"><%= c.getFecha() %></td>
                                    <td><span class="badge badge-tienda px-3 py-2"><%= c.getNombreTienda() %></span></td>
                                    <td class="text-end pe-4 fw-bold text-dark"><%= String.format("%.2f", c.getImporte()) %>€</td>
                                </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        
        <div class="mt-4 text-end">
            <a href="compras.jsp" class="btn btn-primary shadow-sm">
                <i class="bi bi-plus-lg"></i> Añadir Gasto
            </a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="./js/alertify.min.js"></script>
    <script>
        alertify.set('notifier','position', 'bottom-right');
        <% if(usuario != null) { %>
            alertify.success('Bienvenido de nuevo, <%= usuario %>');
        <% } %>
    </script>
</body>
</html>