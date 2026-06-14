import { Code, ExternalLink } from "lucide-react";

interface ProjectCardProps {
  title: string;
  role: string;
  period: string;
  description: string;
  link?: string;
  technologies?: string[];
  delay?: number;
}

export function ProjectCard({
  title,
  role,
  period,
  description,
  link,
  technologies,
  delay = 0,
}: ProjectCardProps) {
  return (
    <div
      className="animate-slide-up"
      style={{ animationDelay: `${delay}ms` }}
    >
      <div className="bg-card rounded-lg p-5 border border-border hover:border-primary/50 transition-all duration-300 hover:shadow-lg h-full flex flex-col">
        <div className="flex items-start justify-between gap-4 mb-3">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-secondary rounded-lg">
              <Code className="w-5 h-5 text-primary" />
            </div>
            <div>
              <h3 className="font-mono font-semibold text-foreground">{title}</h3>
              <p className="text-primary text-sm">{role}</p>
            </div>
          </div>
          <span className="text-sm text-muted-foreground whitespace-nowrap font-mono">
            {period}
          </span>
        </div>
        
        <p className="text-muted-foreground text-sm leading-relaxed mb-4 flex-grow">
          {description}
        </p>
        
        {technologies && technologies.length > 0 && (
          <div className="flex flex-wrap gap-2 mb-4">
            {technologies.map((tech) => (
              <span
                key={tech}
                className="px-2 py-1 bg-secondary rounded text-xs text-muted-foreground font-mono"
              >
                {tech}
              </span>
            ))}
          </div>
        )}

        {link && (
          <a
            href={link}
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-2 text-sm text-primary hover:underline font-mono"
          >
            <ExternalLink className="w-4 h-4" />
            View Project
          </a>
        )}
      </div>
    </div>
  );
}
