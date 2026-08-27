import { useEffect, useState } from 'react';
import { useLocation } from 'react-router-dom';
import { LuArrowRight, LuX } from 'react-icons/lu';

import useProImpression from '../../hooks/useProImpression';
import { PRO_UPSELLS } from '../../constants/Pro';
import { proComponentPreview, proLinkProps } from '../../utils/pro';
import './ProCardMobile.css';

const DISMISSED_KEY = 'react-bits-pro-mobile-dismissed';
const REVEAL_SCROLL_Y = 240;

const ProCardMobile = () => {
  const { pathname } = useLocation();
  const category = pathname.split('/').filter(Boolean)[0];
  const config = PRO_UPSELLS[category] || PRO_UPSELLS.default;
  const [visible, setVisible] = useState(false);
  const [dismissed, setDismissed] = useState(() => {
    if (typeof window === 'undefined') return false;
    return window.sessionStorage.getItem(DISMISSED_KEY) === 'true';
  });
  const impressionRef = useProImpression('mobile-bar', { category: category || 'unknown' }, visible && !dismissed);

  useEffect(() => {
    if (dismissed) return undefined;

    const update = () => setVisible(window.scrollY >= REVEAL_SCROLL_Y);
    update();
    window.addEventListener('scroll', update, { passive: true });
    return () => window.removeEventListener('scroll', update);
  }, [dismissed]);

  if (dismissed) return null;

  const dismiss = () => {
    window.sessionStorage.setItem(DISMISSED_KEY, 'true');
    setDismissed(true);
  };

  return (
    <aside ref={impressionRef} className={`pro-mobile-shell${visible ? ' is-visible' : ''}`} aria-hidden={!visible}>
      <a
        {...proLinkProps(config.path, 'mobile-bar', {
          params: { category: category || 'unknown' },
          sameTab: true
        })}
        className="pro-mobile-bar"
        tabIndex={visible ? undefined : -1}
        aria-label={`Explore React Bits Pro ${config.noun}`}
      >
        <img
          className="pro-mobile-bar-image"
          src={proComponentPreview(config.featured[0].slug).poster}
          alt=""
          aria-hidden="true"
        />
        <span className="pro-mobile-bar-text">
          <span className="pro-mobile-bar-label">React Bits Pro</span>
          <strong>Explore more {config.noun}</strong>
        </span>
        <span className="pro-mobile-bar-cta">
          <LuArrowRight size={13} />
        </span>
      </a>

      <button className="pro-mobile-dismiss" type="button" onClick={dismiss} aria-label="Dismiss React Bits Pro">
        <LuX size={14} />
      </button>
    </aside>
  );
};

export default ProCardMobile;
