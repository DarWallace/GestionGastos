package es.studium.gestion;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/servletGestion")
public class servletGestion extends HttpServlet {
	private static final long serialVersionUID = 1L;
       Modelo modelo = new Modelo();
    
    public servletGestion() {
        super();
       
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
  

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		request.setCharacterEncoding("UTF-8");

		// 1. Leemos qué operación quiere hacer el usuario
	    String op = request.getParameter("op");

	    // 2. Si 'op' es null, es que viene del Login (index.jsp)
	    if (op == null) {
	        String nombre = request.getParameter("nombre");
	        String clave = request.getParameter("clave");
	        
	        if (modelo.validarUsuario(nombre, clave)) {
	            // 1. Buscamos el ID de ese usuario (tendrás que crear este método en el modelo)
	            int idUsuario = modelo.obtenerIdUsuario(nombre); 
	            
	            // 2. Guardamos AMBOS en la sesión
	            request.getSession().setAttribute("usuario", nombre);
	            request.getSession().setAttribute("idUsuario", idUsuario); // <--- CLAVE
	            
	            response.sendRedirect("principal.jsp?login=true");
	        } else {
	            // Login incorrecto: Volvemos al index con el error
	            request.setAttribute("errorLogin", "Usuario o clave incorrectos");
	            request.getRequestDispatcher("index.jsp").forward(request, response);
	        }
	    } 
	    else if (op.equals("0")) { 
	        // 1. Obtenemos la sesión actual
	        HttpSession sesion = request.getSession(false);
	        if (sesion != null) {
	            // 2. La destruimos completamente
	            sesion.invalidate();
	        }
	        // 3. Redirigimos al login
	        response.sendRedirect("index.jsp");
	    }
	    // 3. Operación de ELIMINAR (op=3)
	    else if (op.equals("3")) {
	        int idEliminar = Integer.parseInt(request.getParameter("id"));
	        modelo.eliminarCompra(idEliminar);
	        // Volvemos a la principal y pasamos el parámetro res=deleted para el Alertify
	        response.sendRedirect("principal.jsp?res=deleted");
	    }
	 // Ir al formulario de Nueva Compra
	    else if (op.equals("1")) {
	        List<Tienda> tiendas = modelo.obtenerNombresTiendas();
	        request.setAttribute("listaTiendas", tiendas);
	        request.getRequestDispatcher("compras.jsp").forward(request, response);
	    }

	    // Procesar el guardado de la Nueva Compra
	    else if (op.equals("10")) { // Usamos el 10 para diferenciar el "ir" del "guardar"
	        String fecha = request.getParameter("fecha");
	        double importe = Double.parseDouble(request.getParameter("importe"));
	        int idTienda = Integer.parseInt(request.getParameter("idTienda"));
	        
	        // Suponiendo que guardaste el idUsuario en sesión al hacer login
	        // Si no lo tienes, de momento puedes poner uno a piñón (ej: 1) para probar
	        int idUsuario = (int) request.getSession().getAttribute("idUsuario"); 

	        modelo.insertarCompra(fecha, importe, idTienda, idUsuario);
	        response.sendRedirect("principal.jsp?res=inserted");
	    }
	 // Operación 2: IR A EDITAR COMPRA
	    else if (op.equals("2")) {
	        int idCompra = Integer.parseInt(request.getParameter("id"));
	        
	        // 1. Obtenemos los datos de la compra específica
	        Compra compraAEditar = modelo.obtenerCompraPorId(idCompra);
	        // 2. Necesitamos las tiendas para el desplegable
	        List<Tienda> tiendas = modelo.obtenerNombresTiendas();
	        
	        request.setAttribute("compra", compraAEditar);
	        request.setAttribute("listaTiendas", tiendas);
	        // Reutilizamos compras.jsp
	        request.getRequestDispatcher("compras.jsp").forward(request, response);
	    }
	    else if (op.equals("20")) {
	        int id = Integer.parseInt(request.getParameter("idCompra"));
	        String fecha = request.getParameter("fecha");
	        double importe = Double.parseDouble(request.getParameter("importe"));
	        int idTienda = Integer.parseInt(request.getParameter("idTienda"));
	        String origen = request.getParameter("origen");

	        modelo.actualizarCompra(id, fecha, importe, idTienda);
	        
	        if (origen != null && origen.contains("op=6")) {
	            response.sendRedirect("servletGestion?op=6&res=editOK");
	        } else {
	            response.sendRedirect("principal.jsp?res=editOK");
	        }
	    }
	 // Operación 5: IR A GESTIÓN DE TIENDAS
	    else if (op.equals("5")) {
	        List<Tienda> tiendas = modelo.obtenerNombresTiendas();
	        request.setAttribute("listaTiendas", tiendas);
	        request.getRequestDispatcher("tiendas.jsp").forward(request, response);
	    }

	    // Operación 50: GUARDAR NUEVA TIENDA
	    else if (op.equals("50")) {
	        String nombreTienda = request.getParameter("nombreTienda");
	        modelo.insertarTienda(nombreTienda);
	        // Redirigimos de nuevo a la gestión de tiendas con aviso
	        response.sendRedirect("servletGestion?op=5&res=tiendaOK");
	    }
	    //  ACTUALIZAR TIENDA
	    else if (op.equals("51")) {
	        int id = Integer.parseInt(request.getParameter("idTiendaEdit"));
	        String nombre = request.getParameter("nombreTiendaEdit");
	        modelo.actualizarTienda(id, nombre);
	        response.sendRedirect("servletGestion?op=5&res=tiendaEditOK");
	    }

	    // BORRAR TIENDA
	    else if (op.equals("52")) {
	        int id = Integer.parseInt(request.getParameter("id"));
	        boolean exito = modelo.eliminarTienda(id);
	        if(exito) {
	            response.sendRedirect("servletGestion?op=5&res=tiendaBorradaOK");
	        } else {
	            response.sendRedirect("servletGestion?op=5&res=errorBorrado");
	        }
	    }
	    else if (op.equals("6")) {
	        int idUsuario = (int) request.getSession().getAttribute("idUsuario");
	        String mesSeleccionado = request.getParameter("mesFiltro");
	        
	     // Obtenemos la lista dinámica de meses para el desplegable
	        List<String[]> listaMeses = modelo.obtenerMesesConCompras(idUsuario);
	        
	        // Si es la primera vez que entra, seleccionamos el más reciente
	        if (mesSeleccionado == null && !listaMeses.isEmpty()) {
	            mesSeleccionado = listaMeses.get(0)[0];
	        }
	        
	     // Obtenemos las compras y el total
	        List<Compra> comprasMes = modelo.obtenerComprasPorMes(idUsuario, mesSeleccionado);
	        
	        // Calculamos el total de ese mes específico
	        double totalMes = 0;
	        for(Compra c : comprasMes) { totalMes += c.getImporte(); }
	        
	     // Mandamos todo al JSP, incluyendo la nueva lista de meses
	        request.setAttribute("listaMeses", listaMeses); 
	        request.setAttribute("comprasMes", comprasMes);
	        request.setAttribute("totalMes", totalMes);
	        request.setAttribute("mesActual", mesSeleccionado);
	        request.getRequestDispatcher("informes.jsp").forward(request, response);
	    }

}}
