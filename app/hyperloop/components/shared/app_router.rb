class AppRouter < Hyperloop::Router
  history :browser

  route do
    DIV {
      Switch do
        Route('/', exact: true, mounts: Home)
        Route('/members', exact: true, mounts: Members)
        Route('/l', exact: true, mounts: PageLayout)
        Route('/school', exact: true, mounts: School::Index)
      end
    }
  end
end
