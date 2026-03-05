<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Iniciar Sesión - Gestión de Gastos</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <link rel="stylesheet" href="./css/alertify.min.css" />
    <link rel="stylesheet" href="./css/themes/default.min.css" />
    <link rel="stylesheet" href="./css/estilo.css" />

</head>
<body class="body1">

    <div class="container d-flex justify-content-center">
        
        <div class="card login-card shadow-lg z-index-n1 mt-5">
            <div class="card-body p-4 p-md-5">
                
                <div class="text-center mb-4">
                    <img src="./img/image.png" alt="Logo Aplicación" class="img-fluid mb-3" style="max-height: 120px;" />
                    <h4 class="fw-bold text-secondary">Bienvenido</h4>
             </div>

                <form action="servletGestion" method="post"> <div class="mb-3">
                        <label for="nombreUsuario" class="form-label fw-semibold">Usuario</label>
    					<div class="input-group">
        					<span class="input-group-text bg-light"><i class="bi bi-person-fill"></i></span>
        					<input type="text" class="form-control form-control-lg bg-light fs-6" id="nombreUsuario" name="nombre" placeholder="Tu usuario" required autofocus />
    					</div>
    				</div>
                    

                    <div class="mb-4">
                         <label for="claveUsuario" class="form-label fw-semibold">Contraseña</label>
    						<div class="input-group">
        						<span class="input-group-text bg-light"><i class="bi bi-lock-fill"></i></span>
        						<input type="password" class="form-control form-control-lg bg-light fs-6" id="claveUsuario" name="clave" placeholder="*******" required />
   							 </div>
                    </div>

                    <div class="row gx-2">
                        <div class="col-6">
                            <button type="submit" class="btn btn-success btn-lg w-100 fw-bold shadow-sm fs-6">
                                Aceptar
                            </button>
                        </div>
                        <div class="col-6">
                            <button type="reset" class="btn btn-outline-secondary btn-lg w-100 fw-bold shadow-sm fs-6">
                                Cancelar
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script src="./js/alertify.min.js"></script>

    <script type="text/javascript">
        // Configuramos la posición de las alertas (opcional, pero queda bien)
        alertify.set('notifier','position', 'top-right');
                
    </script>
<%-- Código para capturar el error del Servlet --%>
<%
    String error = (String) request.getAttribute("errorLogin");
    if(error != null) {
%>
    <script type="text/javascript">
        alertify.error("<%= error %>");
    </script>
<%
    }
%>
</body>
</html>