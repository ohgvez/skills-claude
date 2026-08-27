import { useLocation } from 'react-router-dom';
import useProImpression from '../../hooks/useProImpression';
import { PRO_COUNTS, PRO_UPSELLS } from '../../constants/Pro';
import { proComponentPreview, proLinkProps } from '../../utils/pro';
import ReactBitsProLogo from '../../assets/logos/react-bits-pro-logo.svg';

const ProCard = () => {
  const { pathname } = useLocation();
  const category = pathname.split('/').filter(Boolean)[0];
  const config = PRO_UPSELLS.default;
  const impressionRef = useProImpression('right-panel-card', { category: category || 'unknown' });

  return (
    <a
      ref={impressionRef}
      {...proLinkProps(config.path, 'right-panel-card', {
        params: { category: category || 'unknown' },
        sameTab: true
      })}
      className="pro-card-link"
    >
      <article className="pro-card">
        <div className="pro-card-preview is-aurora" aria-hidden="true">
          <img src={proComponentPreview(config.featured[0].slug).poster} alt="" loading="lazy" decoding="async" />
          <img className="pro-card-brand" src={ReactBitsProLogo} alt="" />
        </div>

        <div className="pro-card-content">
          <h3 className="pro-card-title">{config.title}</h3>
          <p className="pro-card-desc">{config.description}</p>
          <div className="pro-card-counts">
            <span>
              {PRO_COUNTS.components} Components · {PRO_COUNTS.blocks} Blocks
            </span>
            <span>
              {PRO_COUNTS.appUi} App UI · {PRO_COUNTS.templates} Templates · {PRO_COUNTS.agentKit} Agent Skills
            </span>
          </div>

          <div className="pro-card-cta ln-navbar-pro">
            <span>Explore React Bits Pro</span>
          </div>
        </div>
      </article>
    </a>
  );
};

export default ProCard;
