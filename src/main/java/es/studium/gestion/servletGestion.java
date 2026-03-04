package es.studium.gestion;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/servletGestion")
public class servletGestion extends HttpServlet {
	private static final long serialVersionUID = 1L;
       Modelo modelo = new Modelo();
    
    public servletGestion() {
        super();
       
    }

  

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		request.setCharacterEncoding("UTF-8");

		response.setContentType("text/html");
		String nombre = request.getParameter("nombre");
		String clave = request.getParameter("clave");
		
		if (modelo.validarUsuario(nombre, clave)) {
            // Comprobamos el usuario
            // Creamos sesión para mantener al usuario identificado
            HttpSession session = request.getSession();
            session.setAttribute("usuario", nombre);
            
            // Redirigimos a la página principal
            response.sendRedirect("principal.jsp");
        } else {
            // LOGIN INCORRECTO
            // Enviamos un atributo de error para que Alertify lo muestre
            request.setAttribute("errorLogin", "Usuario o clave incorrectos");
            // Usamos forward para volver al index manteniendo el mensaje de error
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    
	}

}
