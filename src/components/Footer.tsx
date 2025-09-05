import { Link } from "react-router-dom";
import { Mail, Twitter, Facebook, Instagram, Linkedin, Heart, Youtube } from "lucide-react";

export default function Footer() {
  const handleDonation = () => {
    // Replace this with your donation link or logic
    window.open("https://www.paypal.com/ke/home", "_blank");
  };

  return (
    <footer className="bg-gray-900 text-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          {/* Brand Section */}
          <div>
            <div className="flex items-center space-x-3 mb-4">
              <div className="w-8 h-8 bg-gradient-to-br from-orange-500 to-red-600 rounded-lg flex items-center justify-center">
                <span className="text-white font-bold text-sm">AEN</span>
              </div>
              <div>
                <span className="text-xl font-bold">AfriEuropa News</span>
                <div className="text-xs text-gray-400 -mt-1">Bridge Between Continents</div>
              </div>
            </div>
            <p className="text-gray-400 mb-4">
              Your trusted source for African diaspora articles and opportunities across Europe.
            </p>

            {/* Donation Button */}
            <button
              onClick={handleDonation}
              className="inline-flex items-center space-x-2 bg-orange-600 hover:bg-orange-700 text-white px-6 py-3 rounded-lg font-medium transition-colors"
            >
              <Heart className="h-5 w-5" />
              <span>Buy Us a Coffee</span>
            </button>
          </div>

          {/* Categories */}
          <div>
            <h3 className="text-lg font-semibold mb-4">Categories</h3>
            <ul className="space-y-2 text-gray-400">
              <li><Link to="/category/news" className="hover:text-orange-500 transition-colors">News</Link></li>
              <li><Link to="/category/policy-migration" className="hover:text-orange-500 transition-colors">Policy & Migration</Link></li>
              <li><Link to="/category/culture-lifestyle" className="hover:text-orange-500 transition-colors">Culture & Lifestyle</Link></li>
              <li><Link to="/category/profiles-voices" className="hover:text-orange-500 transition-colors">Profiles & Voices</Link></li>
              <li><Link to="/category/travel-mobility" className="hover:text-orange-500 transition-colors">Travel & Mobility</Link></li>
              <li><Link to="/category/business-jobs" className="hover:text-orange-500 transition-colors">Business & Jobs</Link></li>
              <li><Link to="/category/events" className="hover:text-orange-500 transition-colors">Events</Link></li>
            </ul>
          </div>

          {/* Company */}
          <div>
            <h3 className="text-lg font-semibold mb-4">Company</h3>
            <ul className="space-y-2 text-gray-400">
              <li><Link to="/about" className="hover:text-orange-500 transition-colors">About Us</Link></li>
              <li><Link to="/editorial" className="hover:text-orange-500 transition-colors">Editorial Policy</Link></li>
              <li><Link to="/advertise" className="hover:text-orange-500 transition-colors">Advertise</Link></li>
              <li><Link to="/contact" className="hover:text-orange-500 transition-colors">Contact</Link></li>
              <li><Link to="/privacy" className="hover:text-orange-500 transition-colors">Privacy Policy</Link></li>
            </ul>
          </div>

          {/* Social Media */}
          <div>
            <h3 className="text-lg font-semibold mb-4">Follow Us</h3>
            <div className="flex space-x-4">
              <a
                href="https://linkedin.com/company/diaspora-lens"
                target="_blank"
                rel="noopener noreferrer"
                className="text-gray-300 hover:text-white transition-colors"
                title="LinkedIn"
              >
                <Linkedin className="h-6 w-6" />
              </a>
              <a
                href="https://twitter.com/diaspora_lens"
                target="_blank"
                rel="noopener noreferrer"
                className="text-gray-300 hover:text-white transition-colors"
                title="Twitter"
              >
                <Twitter className="h-6 w-6" />
              </a>
              <a
                href="https://instagram.com/diaspora.lens"
                target="_blank"
                rel="noopener noreferrer"
                className="text-gray-300 hover:text-white transition-colors"
                title="Instagram"
              >
                <Instagram className="h-6 w-6" />
              </a>
              <a
                href="https://youtube.com/@DiasporaLens"
                target="_blank"
                rel="noopener noreferrer"
                className="text-gray-300 hover:text-white transition-colors"
                title="YouTube"
              >
                <Youtube className="h-6 w-6" />
              </a>
            </div>
          </div>
        </div>

        {/* Footer Bottom */}
        <div className="border-t border-gray-800 mt-8 pt-8 text-center text-gray-400">
          <p>&copy; {new Date().getFullYear()} AfriEuropa News. All rights reserved.</p>
        </div>
      </div>
    </footer>
  );
}
