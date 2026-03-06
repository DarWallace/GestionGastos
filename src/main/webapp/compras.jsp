<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.time.LocalDate, es.studium.gestion.Compra, es.studium.gestion.Tienda" %>

<%
    // 1. Detectamos si venimos de "Editar" (op=2) o de "Nueva" (op=1)
    Compra c = (Compra) request.getAttribute("compra");
  List<Tienda> tiendas = (List<Tienda>) request.getAttribute("listaTiendas");
    
    boolean editando = (c != null);
    
    // 2. Configuramos variables dinámicas
    String titulo = editando ? "Editar Compra" : "Nueva Compra";
    String operacion = editando ? "20" : "10"; // 20 para actualizar, 10 para insertar
    String fechaValor = editando ? c.getFecha() : LocalDate.now().toString();
    double importeValor = editando ? c.getImporte() : 0.0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= titulo %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="./css/estilo.css" />
</head>
<body class="body2 pt-5">
    <div class="container">
        <div class="card shadow mx-auto" style="max-width: 500px;">
            <div class="card-header bg-dark text-white text-center">
                <h4 class="mb-0"><%= titulo %></h4>
            </div>
            <div class="card-body p-4">
                <form action="servletGestion" method="post">
                    <input type="hidden" name="op" value="<%= operacion %>">
                    <input type="hidden" name="origen" value="<%= request.getHeader("Referer") %>">
                    
                    <% if(editando) { %>
                        <input type="hidden" name="idCompra" value="<%= c.getIdCompra() %>">
                    <% } %>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Fecha:</label>
                        <input type="date" name="fecha" class="form-control" value="<%= fechaValor %>" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Establecimiento:</label>
                        <div class="input-group">
                            <select name="idTienda" class="form-select" required>
                                <option value="" disabled <%= !editando ? "selected" : "" %>>Elegir Tienda...</option>
                                <% for(Tienda t : tiendas) { 
                                    // Si estamos editando, marcamos como 'selected' la tienda que ya tiene la compra
                                    String selected = (editando && t.getNombreTienda().equals(c.getNombreTienda())) ? "selected" : "";
                                %>
                                    <option value="<%= t.getIdTienda() %>" <%= selected %>><%= t.getNombreTienda() %></option>
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
                            <input type="number" step="0.01" name="importe" class="form-control" 
                                   placeholder="0.00" value="<%= editando ? importeValor : "" %>" required>
                            <span class="input-group-text">€</span>
                        </div>
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-between">
                        <a href="principal.jsp" class="btn btn-light border flex-grow-1">Cancelar</a>
                        <% if(!editando) { %>
                            <button type="reset" class="btn btn-outline-warning">Limpiar</button>
                        <% } %>
                        <button type="submit" class="btn btn-success flex-grow-1">
                            <%= editando ? "Guardar Cambios" : "Aceptar" %>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>