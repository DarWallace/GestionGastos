package es.studium.gestion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import javax.naming.InitialContext;
import javax.sql.DataSource;

public class Modelo {
    private DataSource pool;
    private Connection conn = null;
    private Statement stmt = null;
    private ResultSet rs = null;

    public Modelo() {
        try {
            InitialContext ctx = new InitialContext();
            pool = (DataSource) ctx.lookup("java:comp/env/jdbc/gastos");
        } catch (Exception ex) {
            System.out.println("Error al inicializar el DataSource");
        }
    }

    
    private void conectar() {
        try {
            if (conn == null || conn.isClosed()) {
                conn = pool.getConnection();
            }
        } catch (SQLException e) {
            System.out.println("Error al conectar: " + e.getMessage());
        }
    }

    
    private void desconectar() {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            System.out.println("Error al desconectar");
        }
    }

    public boolean validarUsuario(String nombre, String clave) {
        boolean loginCorrecto = false;
        String sql = "SELECT * FROM usuarios WHERE nombreUsuario = '" + nombre + 
                     "' AND claveUsuario = SHA2('" + clave + "', 256)";
        try {
            conectar(); 
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            
            if (rs.next()) {
                loginCorrecto = true;
            }
        } catch (SQLException e) {
            System.out.println("Error en validarUsuario");
        } finally {
            desconectar(); // Limpiamos todo al terminar
        }
        return loginCorrecto;
    }
    
    public String[] obtenerRangoFechas() {
        String[] rango = new String[2]; // [0] min, [1] max
        String sql = "SELECT MIN(fechaCompra) as primero, MAX(fechaCompra) as ultimo FROM compras";
        try {
            conectar();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                rango[0] = rs.getString("primero");
                rango[1] = rs.getString("ultimo");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener rango de fechas");
        } finally {
            desconectar();
        }
        return rango;
    }
    
    public List<Compra> obtenerComprasMes(int mes, int anio) {
        List<Compra> lista = new ArrayList<>();
        // SQL: Unimos compras con tiendas para sacar el nombre de la tienda
        String sql = "SELECT c.idCompra, c.fechaCompra, c.importeCompra, t.nombreTienda " +
                     "FROM compras c INNER JOIN tiendas t ON c.idTiendaFK = t.idTienda " +
                     "WHERE MONTH(c.fechaCompra) = " + mes + " AND YEAR(c.fechaCompra) = " + anio + " " +
                     "ORDER BY c.fechaCompra DESC";
        try {
            conectar();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                lista.add(new Compra(
                    rs.getInt("idCompra"),
                    rs.getString("fechaCompra"),
                    rs.getDouble("importeCompra"),
                    rs.getString("nombreTienda")
                ));
            }
        } catch (SQLException e) {
            System.out.println("Error al listar compras: " + e.getMessage());
        } finally {
            desconectar();
        }
        return lista;
    }

    public double calcularTotalMes(int mes, int anio) {
        double total = 0;
        String sql = "SELECT SUM(importeCompra) as total FROM compras " +
                     "WHERE MONTH(fechaCompra) = " + mes + " AND YEAR(fechaCompra) = " + anio;
        try {
            conectar();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                total = rs.getDouble("total");
            }
        } catch (SQLException e) {
            System.out.println("Error al calcular total");
        } finally {
            desconectar();
        }
        return total;
    }
}