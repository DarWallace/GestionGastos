package es.studium.gestion;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
		
	}

}
