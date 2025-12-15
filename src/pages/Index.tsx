import { ProfileSidebar } from "@/components/ProfileSidebar";
import { MainContent } from "@/components/MainContent";
import { Helmet } from "react-helmet";

const Index = () => {
  return (
    <>
      <Helmet>
        <title>Mihály Varga | Senior Software Engineer</title>
        <meta
          name="description"
          content="Senior Software Engineer specializing in Microsoft technologies, Azure, C#, .NET Core, and Entity Framework. Building robust web and desktop applications."
        />
        <meta name="keywords" content="Mihály Varga, Software Engineer, C#, .NET, Azure, Developer, Hungary" />
        <meta property="og:title" content="Mihály Varga | Senior Software Engineer" />
        <meta property="og:description" content="Senior Software Engineer specializing in Microsoft technologies and Azure solutions." />
        <meta property="og:type" content="website" />
        <link rel="canonical" href="https://vargamihaly.github.io" />
      </Helmet>
      
      <div className="min-h-screen bg-background flex flex-col lg:flex-row">
        <ProfileSidebar />
        <MainContent />
      </div>
    </>
  );
};

export default Index;
