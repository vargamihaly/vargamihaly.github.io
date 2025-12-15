import { Briefcase } from "lucide-react";

interface ExperienceCardProps {
  title: string;
  company: string;
  period: string;
  description: string;
  technologies?: string[];
  delay?: number;
}

export function ExperienceCard({
  title,
  company,
  period,
  description,
  technologies,
  delay = 0,
}: ExperienceCardProps) {
  return (
    <div
      className="relative pl-8 pb-8 border-l-2 border-border last:border-l-0 last:pb-0 animate-slide-up"
      style={{ animationDelay: `${delay}ms` }}
    >
      {/* Timeline dot */}
      <div className="absolute left-[-9px] top-0 w-4 h-4 rounded-full bg-primary border-4 border-background" />
      
      <div className="bg-card rounded-lg p-5 border border-border hover:border-primary/50 transition-all duration-300 hover:shadow-lg">
        <div className="flex items-start justify-between gap-4 mb-3">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-secondary rounded-lg">
              <Briefcase className="w-5 h-5 text-primary" />
            </div>
            <div>
              <h3 className="font-mono font-semibold text-foreground">{title}</h3>
              <p className="text-primary text-sm">{company}</p>
            </div>
          </div>
          <span className="text-sm text-muted-foreground whitespace-nowrap font-mono">
            {period}
          </span>
        </div>
        
        <p className="text-muted-foreground text-sm leading-relaxed mb-3">
          {description}
        </p>
        
        {technologies && technologies.length > 0 && (
          <div className="flex flex-wrap gap-2">
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
      </div>
    </div>
  );
}
