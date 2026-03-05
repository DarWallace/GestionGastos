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
	        List<String[]> tiendas = modelo.obtenerNombresTiendas();
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
	 // Operación 5: IR A GESTIÓN DE TIENDAS
	    else if (op.equals("5")) {
	        List<String[]> tiendas = modelo.obtenerNombresTiendas();
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

}}
