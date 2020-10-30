class test {
    public static void main(String[] args) {
        try {
            Class.forName("org.postgresql.Driver");
          }
          catch (java.lang.ClassNotFoundException e) {
            System.out.println(e.getMessage());
            System.out.println("VIRKER IKKE");
          }
    }
}