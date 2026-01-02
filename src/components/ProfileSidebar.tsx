import {MapPin, Mail} from "lucide-react";
import avatarImage from "@/assets/avatar.jpeg";
import { GithubIcon, LinkedinIcon, MusicIcon } from "@/components/icons/BrandIcons";
import { useState } from "react";
import { Dialog, DialogContent } from "@/components/ui/dialog";

export function ProfileSidebar() {
    const [isRickRolled, setIsRickRolled] = useState(false);

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
                        href="mailto:contact@mihaly-varga.com"
                        className="flex items-center gap-3 text-muted-foreground hover:text-primary transition-colors group"
                    >
                        <Mail className="w-5 h-5 group-hover:scale-110 transition-transform"/>
                        <span className="text-sm">contact@mihaly-varga.com</span>
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

                {/* Easter Egg */}
                <div className="w-full mt-8">
                    <button
                        onClick={() => setIsRickRolled(true)}
                        className="flex items-center gap-3 text-muted-foreground/30 hover:text-primary/50 transition-colors group"
                        title="🎵"
                    >
                        <MusicIcon className="w-5 h-5 group-hover:scale-110 transition-transform" />
                        <span className="text-sm opacity-0 group-hover:opacity-50 transition-opacity">...</span>
                    </button>
                </div>
            </div>

            {/* RickRoll Dialog */}
            <Dialog open={isRickRolled} onOpenChange={setIsRickRolled}>
                <DialogContent className="max-w-4xl p-0 bg-black border-primary/30">
                    <div className="aspect-video w-full">
                        <iframe
                            width="100%"
                            height="100%"
                            src="https://www.youtube.com/embed/dQw4w9WgXcQ?autoplay=1"
                            title="You've been Rick Rolled!"
                            frameBorder="0"
                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                            allowFullScreen
                        ></iframe>
                    </div>
                </DialogContent>
            </Dialog>
        </aside>
    );
}
