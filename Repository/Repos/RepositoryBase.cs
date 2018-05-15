
namespace WatchUs.Repository
{
    using System;

    public abstract class RepositoryBase : IDisposable
    {
         #region .ctr
       /// <summary>
       /// repository base
       /// </summary>
       /// <param name="context">WatchUs Entities</param>
        internal RepositoryBase(WatchUsEntities context)
        {
            Context = context;
            //Context.CommandTimeout = 3600; //later on move the value to app.config file
        }
        #endregion

        #region IDisposable
        /// <summary>
        /// dispose method
        /// </summary>
        public void Dispose()
        {
            if (Context != null)
            {
                Context.Dispose();
            }
        }
        #endregion

        #region Protected Properties
        /// <summary>
        /// The  context
        /// </summary>
        protected WatchUsEntities Context
        {
            get;
            set;
        }
        #endregion
    }
}
