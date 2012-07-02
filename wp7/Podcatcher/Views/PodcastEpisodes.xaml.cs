﻿using System;
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
using Microsoft.Phone.Controls;
using Podcatcher.ViewModels;

namespace Podcatcher.Views
{
    public partial class PodcastEpisodes : PhoneApplicationPage
    {
        private PodcastSqlModel m_podcastSqlModel;

        public PodcastEpisodes()
        {
            InitializeComponent();
            m_podcastSqlModel = PodcastSqlModel.getInstance();
        }

        protected override void OnNavigatedTo(System.Windows.Navigation.NavigationEventArgs e)
        {
            int podcastId = int.Parse(NavigationContext.QueryString["podcastId"]);
            PodcastSubscriptionModel subscription = m_podcastSqlModel.subscriptionModelForIndex(podcastId);
            List<PodcastEpisodeModel> episodes = subscription.Episodes.ToList();

            this.PodcastName.Text           = subscription.PodcastName;
            this.PodcastDescription.Text    = subscription.PodcastDescription;
            this.EpisodeList.ItemsSource    = episodes;
            this.PodcastIcon.Source         = subscription.PodcastLogo;
        }
    }
}