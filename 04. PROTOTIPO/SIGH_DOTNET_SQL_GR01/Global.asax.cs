using System.Web;
using System.Web.Helpers;
using System.Web.Routing;

namespace SighDotNet
{
    public class MvcApplication : HttpApplication
    {
        protected void Application_Start()
        {
            AntiForgeryConfig.CookieName = "SighUnificadoFormulario";
            RouteConfig.RegisterRoutes(RouteTable.Routes);
        }
    }
}
