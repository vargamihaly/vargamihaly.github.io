import { TechBadge } from "./TechBadge";
import { ExperienceCard } from "./ExperienceCard";
import { EducationCard } from "./EducationCard";
import { FileText, Code, Briefcase, GraduationCap, Mail } from "lucide-react";
import { Button } from "@/components/ui/button";

const skills = {
    backendAndArchitecture: [
        { name: ".NET 8/9", color: "bg-purple-600" },
        { name: "C#", color: "bg-purple-500" },
        { name: "ASP.NET Core", color: "bg-indigo-600" },
        { name: "Entity Framework", color: "bg-blue-600" },
        { name: "RabbitMQ", color: "bg-orange-500" }
    ],

    cloudAndDevOps: [
        { name: "Azure", color: "bg-blue-500" },
        { name: "Docker", color: "bg-sky-600" },
        { name: "CI/CD Pipelines", color: "bg-orange-600" },
        { name: "PowerShell", color: "bg-gray-600" }
    ],

    securityAndIdentity: [
        { name: "OAuth 2.0 / OIDC", color: "bg-emerald-600" },
        { name: "Keycloak", color: "bg-emerald-800" }
    ],

    frontendAndDesktop: [
        { name: "TypeScript", color: "bg-blue-500" },
        { name: "WPF & MVVM", color: "bg-cyan-600" }
    ],

    aiAndIntegration: [
        { name: "Semantic Kernel", color: "bg-pink-600" },
        { name: "Azure OpenAI", color: "bg-blue-600" },
        { name: "RAG Architecture", color: "bg-indigo-500" },
        { name: "AI Agents", color: "bg-violet-600" }
    ],

    methodologies: [
        { name: "SAFe (Scaled Agile)", color: "bg-slate-600" },
        { name: "TDD / Unit Testing", color: "bg-green-600" }
    ]
};

const categoryLabels: Record<string, string> = {
    backendAndArchitecture: "Backend & Core Architecture",
    cloudAndDevOps: "Cloud & DevOps",
    securityAndIdentity: "Security & Identity",
    frontendAndDesktop: "Frontend & Desktop",
    aiAndIntegration: "AI & Modernization",
    methodologies: "Methodologies"
};

const experiences = [
  {
    title: ".NET Developer",
    company: "Blackbelt Technology Kft.",
    period: "Sep 2021 - Present",
    description: "Developing enterprise-level applications using ASP.NET MVC, Web APIs, and Entity Framework Core. Implementing message queuing solutions with RabbitMQ.",
    technologies: ["ASP.NET MVC", ".NET Web APIs", "EF Core", "RabbitMQ", "WPF", "NUnit"],
  },
  {
    title: ".NET Trainer",
    company: "Soter-Line Educational Center",
    period: "Sep 2022 - Present",
    description: "Designing and instructing comprehensive courses on .NET development and software engineering, with emphasis on design patterns and best practices.",
    technologies: [".NET", "Design Patterns", "Software Architecture"],
  },
  {
    title: "C# Software Developer",
    company: "Evosoft Hungary Kft.",
    period: "Jun 2018 - Present",
    description: "Full-stack C# development including solution architecture, debugging, troubleshooting, and comprehensive testing. Building desktop applications with WPF using MVVM pattern.",
    technologies: ["C#", "WPF", "MVVM", "MSSQL", "WCF", "NUnit"],
  },
  {
    title: "Software Test Automation Engineer",
    company: "Evosoft Hungary Kft.",
    period: "Feb 2017 - Jun 2018",
    description: "Developed and maintained automated test suites. Managed test environments and maintained test cases for quality assurance.",
    technologies: ["PowerShell", "Batch", "Test Automation"],
  },
  {
    title: "Software QA Analyst",
    company: "star/trac Supply chain solution GmbH",
    period: "Sep 2015 - Feb 2017",
    description: "Created comprehensive end-to-end test plans. Performed functionality, stability, and performance testing for supply chain solutions.",
    technologies: ["Java EE", "Spring", "Hibernate", "QA"],
  },
];

const education = [
  {
    title: "Computer Scientist (BSc)",
    institution: "University of Nyíregyháza",
    period: "2011 - 2013",
    isCertification: false,
  },
  {
    title: "ISTQB Foundation Level",
    institution: "ISTQB",
    period: "Certification",
    isCertification: true,
  },
  {
    title: "Advanced C#",
    institution: "Professional Certification",
    period: "2018 - 2023",
    isCertification: true,
  },
  {
    title: "Secure Desktop Application Development in C#",
    institution: "Professional Certification",
    period: "2018 - 2023",
    isCertification: true,
  },
];

export function MainContent() {
  return (
    <main className="flex-1 min-h-screen p-6 lg:p-8 xl:p-12 overflow-y-auto">
      {/* Header path */}
      <div className="text-sm text-muted-foreground font-mono mb-8 animate-fade-in">
        <span className="text-primary">vargamihaly</span>
        <span className="mx-1">/</span>
        <span>README</span>
        <span className="text-muted-foreground">.md</span>
      </div>

      {/* Hero Section */}
      <section className="mb-12 animate-slide-up">
        <h2 className="text-3xl lg:text-4xl font-mono font-bold text-foreground mb-4">
          Hi 👋, I'm Mihály Varga
        </h2>
        <p className="text-lg text-muted-foreground leading-relaxed max-w-3xl mb-6">
          I'm a seasoned Senior Software Engineer specializing in Microsoft technologies and Azure solutions 💻. 
          With a strong foundation in C#, .NET Core, and Entity Framework, I focus on creating robust web and 
          desktop applications. My expertise extends to developing RESTful APIs and implementing scalable cloud 
          services, constantly driven by best software design and development practices 🚀.
        </p>
        
        <div className="flex flex-wrap gap-3">
          <Button asChild>
            <a href="mailto:vmisi20@gmail.com">
              <Mail className="w-4 h-4 mr-2" />
              Get in Touch
            </a>
          </Button>
          <Button variant="outline" asChild>
            <a href="https://vargamihaly.github.io/right-resume.pdf" target="_blank" rel="noopener noreferrer">
              <FileText className="w-4 h-4 mr-2" />
              Download CV
            </a>
          </Button>
        </div>
      </section>

        {/* Technologies Section  */}
        <section className="mb-12">
            <div className="flex items-center gap-3 mb-6">
                <Code className="w-6 h-6 text-primary" />
                <h2 className="text-2xl font-mono font-bold text-foreground">Technologies I've Worked With</h2>
            </div>

            <div className="grid gap-6 animate-slide-up" style={{ animationDelay: "100ms" }}>
                {Object.entries(skills).map(([key, items]) => (
                    <div key={key}>
                        <h3 className="text-xs font-semibold text-muted-foreground mb-3 uppercase tracking-wider">
                            {categoryLabels[key] || key}
                        </h3>
                        <div className="flex flex-wrap gap-2">
                            {items.map((tech) => (
                                <TechBadge key={tech.name} name={tech.name} color={tech.color} />
                            ))}
                        </div>
                    </div>
                ))}
            </div>
        </section>

      {/* Experience Section */}
      <section className="mb-12">
        <div className="flex items-center gap-3 mb-6">
          <Briefcase className="w-6 h-6 text-primary" />
          <h2 className="text-2xl font-mono font-bold text-foreground">Work Experience</h2>
        </div>
        <div className="space-y-0">
          {experiences.map((exp, index) => (
            <ExperienceCard
              key={exp.title + exp.company}
              {...exp}
              delay={index * 100}
            />
          ))}
        </div>
      </section>

      {/* Education Section */}
      <section className="mb-12">
        <div className="flex items-center gap-3 mb-6">
          <GraduationCap className="w-6 h-6 text-primary" />
          <h2 className="text-2xl font-mono font-bold text-foreground">Education & Certifications</h2>
        </div>
        <div className="grid gap-4 md:grid-cols-2">
          {education.map((edu, index) => (
            <EducationCard
              key={edu.title}
              {...edu}
              delay={index * 100}
            />
          ))}
        </div>
      </section>

      {/* Footer */}
      <footer className="pt-8 border-t border-border text-center text-muted-foreground text-sm">
        <p>© {new Date().getFullYear()} Mihály Varga. Built with passion for clean code.</p>
      </footer>
    </main>
  );
}
