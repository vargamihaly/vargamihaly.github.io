interface TechBadgeProps {
  name: string;
  color?: string;
}

const techColors: Record<string, string> = {
  "C#": "bg-purple-600",
  ".NET Core": "bg-purple-500",
  "ASP.NET": "bg-purple-700",
  "Entity Framework": "bg-indigo-600",
  "Azure": "bg-blue-500",
  "WPF": "bg-blue-600",
  "MSSQL": "bg-red-600",
  "RabbitMQ": "bg-orange-500",
  "WCF": "bg-cyan-600",
  "NUnit": "bg-green-600",
  "Git": "bg-orange-600",
  "Java": "bg-red-500",
  "Spring": "bg-green-500",
  "Hibernate": "bg-amber-600",
  "PowerShell": "bg-blue-700",
  "MVVM": "bg-teal-600",
  "REST API": "bg-emerald-600",
};

export function TechBadge({ name, color }: TechBadgeProps) {
  const bgColor = color || techColors[name] || "bg-secondary";
  
  return (
    <span
      className={`inline-flex items-center px-3 py-1 rounded-full text-sm font-medium ${bgColor} text-foreground transition-all duration-200 hover:scale-105 hover:shadow-lg`}
    >
      {name}
    </span>
  );
}
