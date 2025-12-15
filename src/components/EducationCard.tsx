import { GraduationCap, Award } from "lucide-react";

interface EducationCardProps {
  title: string;
  institution: string;
  period: string;
  isCertification?: boolean;
  delay?: number;
}

export function EducationCard({
  title,
  institution,
  period,
  isCertification = false,
  delay = 0,
}: EducationCardProps) {
  const Icon = isCertification ? Award : GraduationCap;
  
  return (
    <div
      className="bg-card rounded-lg p-5 border border-border hover:border-primary/50 transition-all duration-300 hover:shadow-lg animate-slide-up"
      style={{ animationDelay: `${delay}ms` }}
    >
      <div className="flex items-start gap-4">
        <div className="p-2 bg-secondary rounded-lg shrink-0">
          <Icon className="w-5 h-5 text-primary" />
        </div>
        <div className="flex-1">
          <h3 className="font-mono font-semibold text-foreground mb-1">{title}</h3>
          <p className="text-primary text-sm mb-1">{institution}</p>
          <span className="text-sm text-muted-foreground font-mono">{period}</span>
        </div>
      </div>
    </div>
  );
}
