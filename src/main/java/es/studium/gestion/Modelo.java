package es.studium.gestion;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class Modelo {
	private DataSource pool;
	Connection conn = null;
	Statement stmt = null;

	public Modelo() {
		try { // Crea un contexto para poder luego buscar el recurso DataSource
			InitialContext ctx = new InitialContext(); // Busca el recurso DataSource en el contexto
			pool = (DataSource) ctx.lookup("java:comp/env/jdbc/gastos");
			if (pool == null) {
				throw new Exception("DataSource desconocida gastos");
			}
			conn = pool.getConnection();

		} catch (NamingException ex) {
			System.out.println("error en nombre");
		} catch (SQLException ex) {System.out.println("error en sql");
		} catch (Exception ex) {System.out.println("excepción");
		}

	}
	public boolean Login (String nombre, String clave)  {
		boolean resp=false;
		
		return resp;
		
	}

}
