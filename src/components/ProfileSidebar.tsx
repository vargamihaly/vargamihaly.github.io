import {MapPin, Mail} from "lucide-react";
import avatarImage from "@/assets/avatar.jpeg";
import { GithubIcon, LinkedinIcon, FacebookIcon } from "@/components/icons/BrandIcons";

export function ProfileSidebar() {
    return (
        <aside
            className="w-full lg:w-80 xl:w-96 bg-sidebar-bg border-r border-sidebar-border p-6 lg:p-8 lg:sticky lg:top-0 lg:h-screen overflow-y-auto">
            <div className="flex flex-col items-center lg:items-start animate-fade-in">
                {/* Avatar */}
                <div className="relative mb-6">
                    <div
                        className="w-48 h-48 lg:w-56 lg:h-56 rounded-full overflow-hidden border-4 border-primary/30 glow">
                        <img
                            src={avatarImage}
                            alt="Mihály Varga"
                            className="w-full h-full object-cover"
                        />
                    </div>
                    <div
                        className="absolute bottom-2 right-2 w-8 h-8 bg-primary rounded-full flex items-center justify-center">
                        <span className="text-primary-foreground text-sm">✓</span>
                    </div>
                </div>

                {/* Name & Title */}
                <h1 className="text-2xl lg:text-3xl font-mono font-bold text-foreground mb-1">
                    Mihály Varga
                </h1>
                <p className="text-lg text-muted-foreground mb-4">Senior Software Engineer</p>

                {/* Bio */}
                <p className="text-muted-foreground text-sm lg:text-base leading-relaxed mb-6 text-center lg:text-left">
                    Seasoned Senior Software Engineer specializing in Microsoft technologies and Azure solutions.
                    Creating robust web and desktop applications with C#, .NET Core, and Entity Framework.
                </p>

                {/* Divider */}
                <div className="w-full h-px bg-border mb-6"/>

                {/* Contact Info */}
                <div className="w-full space-y-3">
                    <a
                        href="mailto:vmisi20@gmail.com"
                        className="flex items-center gap-3 text-muted-foreground hover:text-primary transition-colors group"
                    >
                        <Mail className="w-5 h-5 group-hover:scale-110 transition-transform"/>
                        <span className="text-sm">vmisi20@gmail.com</span>
                    </a>

                    <div className="flex items-center gap-3 text-muted-foreground">
                        <MapPin className="w-5 h-5"/>
                        <span className="text-sm">Hungary</span>
                    </div>
                </div>

                {/* Divider */}
                <div className="w-full h-px bg-border my-6"/>

                {/* Social Links */}
                <div className="w-full space-y-3">
                    <a
                        href="https://github.com/vargamihaly"
                        target="_blank"
                        rel="noopener noreferrer"
                        className="flex items-center gap-3 text-muted-foreground hover:text-primary transition-colors group"
                    >
                        <GithubIcon className="w-5 h-5 group-hover:scale-110 transition-transform"/>
                        <span className="text-sm">vargamihaly</span>
                    </a>

                    <a
                        href="https://www.linkedin.com/in/vmisi20/"
                        target="_blank"
                        rel="noopener noreferrer"
                        className="flex items-center gap-3 text-muted-foreground hover:text-primary transition-colors group"
                    >
                        <LinkedinIcon className="w-5 h-5 group-hover:scale-110 transition-transform"/>
                        <span className="text-sm">vmisi20</span>
                    </a>
                </div>
            </div>
        </aside>
    );
}
