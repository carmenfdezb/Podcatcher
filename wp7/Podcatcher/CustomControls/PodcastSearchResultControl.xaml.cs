﻿/**
 * Copyright (c) 2012, 2013, Johan Paul <johan@paul.fi>
 * All rights reserved.
 * 
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */



using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using System.Diagnostics;
using Microsoft.Phone.Controls;
using Podcatcher.ViewModels;
using System.Windows.Navigation;

namespace Podcatcher.CustomControls
{
    public partial class PodcastSearchResultControl : UserControl
    {
        GPodderResultModel m_searchResultModel;
        PodcastSubscriptionsManager m_subscriptionManager;

        public PodcastSearchResultControl()
        {
            InitializeComponent();
            this.Loaded += new RoutedEventHandler(Page_Loaded);

            m_subscriptionManager = PodcastSubscriptionsManager.getInstance();
        }

        private void Page_Loaded(object sender, RoutedEventArgs e)
        {
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            m_searchResultModel = this.DataContext as GPodderResultModel;
            m_subscriptionManager.addSubscriptionFromURL(m_searchResultModel.PodcastUrl);
        }

        private void ResultTapped(object sender, System.Windows.Input.GestureEventArgs e)
        {
            m_searchResultModel = this.DataContext as GPodderResultModel;

            (Application.Current.RootVisual as PhoneApplicationFrame).Navigate(new Uri(string.Format("/Views/PodcastSubscriptionIntroduction.xaml?podcastUrl={0}", m_searchResultModel.PodcastUrl), UriKind.Relative));
        }
    }
}
