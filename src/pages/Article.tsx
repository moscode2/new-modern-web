
import { useParams } from "react-router-dom";
import { Clock, Share2 } from "lucide-react";
import Header from "../components/Header";
import Footer from "../components/Footer";
import { useStaticData } from "../hooks/useStaticData";


export default function ArticlePage() {
  const { slug } = useParams<{ slug: string }>();
  const { loading, getArticleBySlug } = useStaticData();

  const article = slug ? getArticleBySlug(slug) : null;

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', { 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric' 
    });
  };

  const handleShare = async () => {
    const shareData = {
      title: article?.title || 'AfriEuropa Article',
      text: article?.excerpt || 'Check out this article from AfriEuropa.',
      url: window.location.href,
    };

    try {
      if (navigator.share) {
        await navigator.share(shareData);
      } else {
        await navigator.clipboard.writeText(window.location.href);
        alert('Article link copied to clipboard!');
      }
    } catch (error) {
      // Fallback for older browsers
      prompt('Copy this link to share:', window.location.href);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50">
        <Header />
        <div className="flex items-center justify-center h-64">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-orange-600"></div>
        </div>
      </div>
    );
  }

  if (!article) {
    return (
      <div className="min-h-screen bg-gray-50">
        <Header />
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
          <div className="text-center">
            <h1 className="text-2xl font-bold text-gray-900 mb-4">Article Not Found</h1>
            <p className="text-gray-600">The article you're looking for doesn't exist.</p>
          </div>
        </div>
        <Footer />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <Header />
      
      <article className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Article Header */}
        <header className="mb-8">
          <h1 className="text-3xl lg:text-4xl font-bold text-gray-900 mb-4">
            {article.title}
          </h1>
          
          <div className="flex items-center justify-between mb-6">
            <div className="flex items-center space-x-4 text-gray-600">
              {article.author && (
                <span className="font-medium">By {article.author}</span>
              )}
              {article.published_at && (
                <div className="flex items-center space-x-1">
                  <Clock className="h-4 w-4" />
                  <span>{formatDate(article.published_at)}</span>
                </div>
              )}
            </div>
            
            <button
              onClick={handleShare}
              className="inline-flex items-center space-x-2 text-gray-600 hover:text-orange-600 transition-colors"
            >
              <Share2 className="h-5 w-5" />
              <span>Share</span>
            </button>
          </div>

          {article.excerpt && (
            <p className="text-xl text-gray-700 leading-relaxed mb-6">
              {article.excerpt}
            </p>
          )}
        </header>

        {/* Featured Image */}
        {article.featured_image_url && (
          <div className="mb-8">
            <img
              src={article.featured_image_url}
              alt={article.title}
              className="w-full h-64 lg:h-96 object-cover rounded-lg"
            />
          </div>
        )}

        {/* Article Content */}
        <div className="prose prose-lg max-w-none">
          <div 
            className="text-gray-800 leading-relaxed"
            dangerouslySetInnerHTML={{ __html: article.content.replace(/\n/g, '<br />') }}
          />
        </div>
      </article>

      <Footer />
    </div>
  );
}
