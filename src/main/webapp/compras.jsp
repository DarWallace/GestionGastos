<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.time.LocalDate" %>
<%
    List<String[]> tiendas = (List<String[]>) request.getAttribute("listaTiendas");
    String fechaHoy = LocalDate.now().toString(); // Formato yyyy-mm-dd para el input date
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Nueva Compra</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="./css/estilo.css" />
</head>
<body class="body2 pt-5">
    <div class="container">
        <div class="card shadow mx-auto" style="max-width: 500px;">
            <div class="card-header bg-dark text-white text-center">
                <h4 class="mb-0">Nueva Compra</h4>
            </div>
            <div class="card-body p-4">
                <form action="servletGestion" method="post">
                    <input type="hidden" name="op" value="10">
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Fecha:</label>
                        <input type="date" name="fecha" class="form-control" value="<%= fechaHoy %>" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Establecimiento:</label>
                        <div class="input-group">
                            <select name="idTienda" class="form-select" required>
                                <option value="" selected disabled>Elegir Tienda...</option>
                                <% for(String[] t : tiendas) { %>
                                    <option value="<%= t[0] %>"><%= t[1] %></option>
                                <% } %>
                            </select>
                            <a href="servletGestion?op=5" class="btn btn-outline-secondary" title="Añadir nueva tienda">
                                <i class="bi bi-plus-circle"></i>
                            </a>
                        </div>
                        <div class="form-text">¿No está tu tienda? Pulsa el botón +</div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-bold">Importe:</label>
                        <div class="input-group">
                            <input type="number" step="0.01" name="importe" class="form-control" placeholder="0.00" required>
                            <span class="input-group-text">€</span>
                        </div>
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-between">
                        <a href="principal.jsp" class="btn btn-light border flex-grow-1">Cancelar</a>
                        <button type="reset" class="btn btn-outline-warning">Limpiar</button>
                        <button type="submit" class="btn btn-success flex-grow-1">Aceptar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>