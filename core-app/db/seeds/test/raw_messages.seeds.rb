#id,status,api_key,username,action,url,html,date_captured,date_created,date_updated
RawMessage.create(
  :api_key=>'api_key_1_invalid',
  :username=>'foo@bar.com',
  :action=>'GET',
  :url => 'http://foo.bar',
  :html=>'<html><body><a href="foo">link</a></body></html>',
  :captured_at=>Time::now
)
RawMessage.create(
  :api_key=>'00000000-aaaa-bbbb-cccc-000000000000',
  :username=>'bar@bar.com',
  :action=>'GET',
  :url => 'http://foo.bar',
  :html=>'<html><body><a href="bar">link</a></body></html>',
  :captured_at=>Time::now
)
RawMessage.create({
  :api_key=>'00000000-aaaa-bbbb-dddd-000000000000',
  :username=>'foo@bar.com',
  :action=>'GET',
  :captured_at=>Time::now,
  :url => 'http://www.codeacademy.com/learn/pageFoo',
  :html=> <<-eos
     <article class=fit-fixed>
        <article class=fit-fixed id=header__nav-container>
          <div id=header__nav class="grid-col-12 grid-row grid-col--no-spacing">
            <div id=header__mobile-dropdown-button-container class="grid-col-1 grid-col--no-padding grid-col--no-margin grid-col--float-right" exclude=desktop>
              <a id=header__mobile-dropdown-button class="js-toggle-profile-dropdown header__nav__link">
                <div class=header__nav__link__label>
                  <h5></h5>
                </div>
              </a>
            </div>
              <div class="grid-col-2 grid-col--float-right grid-col--no-spacing" exclude="tablet phone">
                  <a id=header__menu-me class="js-toggle-profile-dropdown header__nav__link">
                    <div id=user-dropdown class=header__nav__link__label>
                      <div class="avatar avatar--small">
                        <img alt="Foo Bar" src="http://www.gravatar.com/avatar/836538af70a1069cd276094d9b464009?d=retro&amp;s=140">
                      </div>
                      <h5>
                        Me
                        <span class=new-cc-icon>downarrow</span></h5>
                    </div>
                  </a>
              </div>
            </div>
          <div id=header__logo>
            <a href="/" id=header__logo__link>
              <img alt=Codecademy class="logo__image--full no-rescale" src="http://cdn-production.codecademy.com/assets/logo/logo--dark-blue-bf11002ce1caecdfb9fec8d3286b8a8d.svg">
    </a>      </div>
        </article>
      </article>
      <div id=notices exclude=phone></div>
    </header>
    <main>
    <article class="cta cta--curricula color-scheme--white fit-full">
      <div class="fit-fixed grid-row">
          <section class="cta__graphic grid-col-8 grid-col--center grid-col--align-center grid-col--no-spacing">
            <span class="cc-symbol icon--large">ruby</span>
          </section>
        <section class="cta__copy grid-col-6 grid-col--center grid-col--align-center grid-col--no-spacing">
          <h1>Ruby</h1>
          <section class=cta__description>
            Learn to program in Ruby, a &#64258;exible language used to create sites like Codecademy.
          </section>
        </section>
        <section class="cta__action grid-col-3 grid-col--center grid-col--align-center grid-col--no-spacing">
          <a href="/tracks/ruby/resume" value="27%" class="button button--large button--fill-space button--secondary">
            Continue<span value="27%" class=cta__action__progress></span>
          </a>
        </section>
      </div>
    </article>
    <article class="dashboard dashboard--curricula color-scheme--white fit-full">
      <div class="dashboard__grid fit-fixed grid-row">
        <section class="dashboard__item grid-col-4 grid-col--align-center grid-col--no-spacing">
          <h3>800k+</h3>
          <p>enrolled students</p>
        </section>
        <section class="dashboard__item grid-col-4 grid-col--align-center grid-col--no-spacing">
          <h3>9 Hours</h3>
          <p>estimated course time</p>
        </section>
        <section class="dashboard__item grid-col-4 grid-col--align-center grid-col--no-spacing">
          <h3>Beginner</h3>
          <p>required technical level</p>
        </section>
      </div>
    </article>
    <article class="syllabus leadin syllabus--curricula fit-full">
        <aside class=syllabus__leadin>
          <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width=64px height=32px viewBox="0 0 64 32" version=1.1><style><!--
.shape{fill: none;fill-rule: evenodd;}.path{fill: #FFFFFF;}
--></style><defs></defs><g class=shape><path d="M0.27734375 0.9 L64.2773438 0.9 L32.2773438 32.9 L0.27734375 0.9 Z" class=path></path></g></svg>
        </aside>
      <div class="fit-fixed grid-row">
        <section class="syllabus__topics grid-col-8 grid-col--center grid-col--no-margin">
            <article class=syllabus__topic>
        <h4>Introduction to Ruby</h4>
        <section class="syllabus__course color-scheme--white">
          <section class=syllabus__course__progress>
            <span class="syllabus__progress syllabus__progress--circle color-scheme--grey" value="100%"></span>
          </section>
          <section class=syllabus__course__description>
            <h5>Introduction to Ruby</h5>
            <div exclude=phone>
              <p>This tutorial will introduce you to Ruby, an object-oriented scripting language you can use on its own or as part of the Ruby on Rails web framework.</p>
            </div>
          </section>
           <a href="/courses/5059d7644188390002000d9a/resume?curriculum_id=5059f8619189a5000201fbcb" class=link--target></a>
        </section>
        <section class="syllabus__course color-scheme--white">
          <section class=syllabus__course__progress>
            <span class="syllabus__progress syllabus__progress--circle color-scheme--grey" value="100%"></span>
          </section>
          <section class=syllabus__course__description>
            <h5>Putting the Form in Formatter</h5>
            <div exclude=phone>
              <p>Now that you know a little bit of Ruby, let's put together your first project! In this one, we'll write a small program that will format a user's input.</p>
            </div>
          </section>
           <a href="/courses/5059e69c418839000200f653/resume?curriculum_id=5059f8619189a5000201fbcb" class=link--target></a>
        </section>
    </article>
            <article class=syllabus__topic>
        <h4>Control Flow in Ruby</h4>
        <section class="syllabus__course color-scheme--white">
          <section class=syllabus__course__progress>
            <span class="syllabus__progress syllabus__progress--circle color-scheme--grey" value="100%"></span>
          </section>
          <section class=syllabus__course__description>
            <h5>Control Flow in Ruby</h5>
            <div exclude=phone>
              <p>Now that we know how to write simple programs, let's learn how to write more complex programs that can respond to user input.</p>
            </div>
          </section>
           <a href="/courses/5059eb0b02ef46000201391d/resume?curriculum_id=5059f8619189a5000201fbcb" class=link--target></a>
        </section>
        <section class="syllabus__course color-scheme--white">
          <section class=syllabus__course__progress>
            <span class="syllabus__progress syllabus__progress--circle color-scheme--grey" value="100%"></span>
          </section>
          <section class=syllabus__course__description>
            <h5>Thith Meanth War!</h5>
            <div exclude=phone>
              <p>Using control flow, we can modify a user's input and return it to them. In this project, we'll make them sound like Daffy Duck!</p>
            </div>
          </section>
           <a href="/courses/505a1a519189a50002040605/resume?curriculum_id=5059f8619189a5000201fbcb" class=link--target></a>
        </section>
    </article>
            <article class=syllabus__topic>
        <h4>Looping with Ruby</h4>
        <section class="syllabus__course color-scheme--white">
          <section class=syllabus__course__progress>
            <span class="syllabus__progress syllabus__progress--circle color-scheme--grey" value="100%"></span>
          </section>
          <section class=syllabus__course__description>
            <h5>Loops &amp; Iterators</h5>
            <div exclude=phone>
              <p>Using loops and iterators, Ruby can automate repetitive tasks for you quickly and easily.</p>
            </div>
          </section>
           <a href="/courses/505a2d545a9b1c000200097b/resume?curriculum_id=5059f8619189a5000201fbcb" class=link--target></a>
        </section>
        <section class="syllabus__course color-scheme--white">
          <section class=syllabus__course__progress>
            <span class="syllabus__progress syllabus__progress--circle color-scheme--grey" value="0%"></span>
          </section>
          <section class=syllabus__course__description>
            <h5>Redacted!</h5>
            <div exclude=phone>
              <p>In this project we'll make a program that searches a string of text for your name and, if it finds it, replaces it with the word "redacted." Just like that, you're a spy!</p>
            </div>
          </section>
           <a href="/courses/505a610a8ff9c90002006c9d/resume?curriculum_id=5059f8619189a5000201fbcb" class=link--target></a>
        </section>
    </article>
            <article class=syllabus__topic>
        <h4>Arrays and Hashes</h4>
        <section class="syllabus__course color-scheme--white">
          <section class=syllabus__course__progress>
            <span class="syllabus__progress syllabus__progress--circle color-scheme--grey" value="0%"></span>
          </section>
          <section class=syllabus__course__description>
            <h5>Data Structures</h5>
            <div exclude=phone>
              <p>You already know a little bit about arrays. This lesson will teach you more about arrays, about a new data structure called a hash, and how Ruby can iterate over both to help you build better programs.</p>
            </div>
          </section>
           <a href="/courses/505a6049f61e6e0002006a33/resume?curriculum_id=5059f8619189a5000201fbcb" class=link--target></a>
        </section>
        <section class="syllabus__course color-scheme--white">
          <section class=syllabus__course__progress>
            <span class="syllabus__progress syllabus__progress--circle color-scheme--grey" value="0%"></span>
          </section>
          <section class=syllabus__course__description>
            <h5>Create a Histogram</h5>
            <div exclude=phone>
              <p>In this project, we'll write a program that reads a block of text and tells us how many times each word appears.</p>
            </div>
          </section>
           <a href="/courses/505a59b28ff9c90002002e98/resume?curriculum_id=5059f8619189a5000201fbcb" class=link--target></a>
        </section>
    </article>
            <article class=syllabus__topic>
        <h4>Blocks and Sorting</h4>
        <section class="syllabus__course color-scheme--white">
          <section class=syllabus__course__progress>
            <span class="syllabus__progress syllabus__progress--circle color-scheme--grey" value="0%"></span>
          </section>
          <section class=syllabus__course__description>
            <h5>Methods, Blocks, &amp; Sorting</h5>
            <div exclude=phone>
              <p>In this lesson, we'll cover how to define our own methods in Ruby, as well as how to use blocks to develop powerful sorting algorithms.</p>
            </div>
          </section>
           <a href="/courses/5060ec19567efa0002007ab1/resume?curriculum_id=5059f8619189a5000201fbcb" class=link--target></a>
        </section>
        <section class="syllabus__course color-scheme--white">
          <section class=syllabus__course__progress>
            <span class="syllabus__progress syllabus__progress--circle color-scheme--grey" value="0%"></span>
          </section>
          <section class=syllabus__course__description>
            <h5>Ordering Your Library</h5>
            <div exclude=phone>
              <p>In this project, we'll design a single Ruby method to sort large quantities of data in either ascending or descending order.</p>
            </div>
          </section>
           <a href="/courses/5065d5adab231f00020c6386/resume?curriculum_id=5059f8619189a5000201fbcb" class=link--target></a>
        </section>
    </article>
            <article class=syllabus__topic>
        <h4>Hashes and Symbols</h4>
        <section class="syllabus__course color-scheme--white">
          <section class=syllabus__course__progress>
            <span class="syllabus__progress syllabus__progress--circle color-scheme--grey" value="0%"></span>
          </section>
          <section class=syllabus__course__description>
            <h5>Hashes and Symbols</h5>
            <div exclude=phone>
              <p>As we've seen, hashes are an important Ruby data structure. Here, we'll learn about the (chunky) bacon to hashes' eggs: symbols!</p>
            </div>
          </section>
           <a href="/courses/50c244c94cfc4bea7500725e/resume?curriculum_id=5059f8619189a5000201fbcb" class=link--target></a>
        </section>
        <section class="syllabus__course color-scheme--white">
          <section class=syllabus__course__progress>
            <span class="syllabus__progress syllabus__progress--circle color-scheme--grey" value="0%"></span>
          </section>
          <section class=syllabus__course__description>
            <h5>A Night at the Movies</h5>
            <div exclude=phone>
              <p>In this project, we'll use our knowledge of Ruby hashes and symbols to construct a program that displays, adds, updates, and removes movie ratings!</p>
            </div>
          </section>
           <a href="/courses/50d110306dfac6428d0020a8/resume?curriculum_id=5059f8619189a5000201fbcb" class=link--target></a>
        </section>
    </article>
            <article class=syllabus__topic>
        <h4>Refactoring</h4>
        <section class="syllabus__course color-scheme--white">
          <section class=syllabus__course__progress>
            <span class="syllabus__progress syllabus__progress--circle color-scheme--grey" value="0%"></span>
          </section>
          <section class=syllabus__course__description>
            <h5>The Zen of Ruby</h5>
            <div exclude=phone>
              <p>In this course, we'll look at the best practices and conventions that make Ruby unique.</p>
            </div>
          </section>
           <a href="/courses/50bcfe55ebc672ba4600046a/resume?curriculum_id=5059f8619189a5000201fbcb" class=link--target></a>
        </section>
        <section class="syllabus__course color-scheme--white">
          <section class=syllabus__course__progress>
            <span class="syllabus__progress syllabus__progress--circle color-scheme--grey" value="0%"></span>
          </section>
          <section class=syllabus__course__description>
            <h5>The Refactor Factory</h5>
            <div exclude=phone>
              <p>In this project, we'll use step-by-step refactoring to vastly improve the readability and structure of a program.</p>
            </div>
          </section>
           <a href="/courses/50ca2acc3f0389c437000203/resume?curriculum_id=5059f8619189a5000201fbcb" class=link--target></a>
        </section>
    </article>
            <article class=syllabus__topic>
        <h4>Blocks, Procs, and Lambdas</h4>
        <section class="syllabus__course color-scheme--white">
          <section class=syllabus__course__progress>
            <span class="syllabus__progress syllabus__progress--circle color-scheme--grey" value="0%"></span>
          </section>
          <section class=syllabus__course__description>
            <h5>Blocks, Procs, and Lambdas</h5>
            <div exclude=phone>
              <p>In this course, we'll cover three of the most powerful aspects of the Ruby programming language: blocks, procs, and lambdas.</p>
            </div>
          </section>
           <a href="/courses/50c2451c55df51ff2700732f/resume?curriculum_id=5059f8619189a5000201fbcb" class=link--target></a>
        </section>
    </article>
            <article class=syllabus__topic>
        <h4>Object-Oriented Programming, Part I</h4>
        <section class="syllabus__course color-scheme--white">
          <section class=syllabus__course__progress>
            <span class="syllabus__progress syllabus__progress--circle color-scheme--grey" value="0%"></span>
          </section>
          <section class=syllabus__course__description>
            <h5>Object-Oriented Programming I</h5>
            <div exclude=phone>
              <p>Ruby is an object-oriented language. In this lesson, we'll cover objects, classes, and how they're used to organize information and behavior in our programs.</p>
            </div>
          </section>
           <a href="/courses/50c2457cd1a23fe8060072ed/resume?curriculum_id=5059f8619189a5000201fbcb" class=link--target></a>
        </section>
        <section class="syllabus__course color-scheme--white">
          <section class=syllabus__course__progress>
            <span class="syllabus__progress syllabus__progress--circle color-scheme--grey" value="0%"></span>
          </section>
          <section class=syllabus__course__description>
            <h5>Virtual Computer</h5>
            <div exclude=phone>
              <p>Often programmers use virtual machines to simulate real computers. While we won't be building a real VM, in this project, we'll use Ruby classes to create our own imaginary computer that stores data!</p>
            </div>
          </section>
           <a href="/courses/50d4b0d808e9ec9a280015d6/resume?curriculum_id=5059f8619189a5000201fbcb" class=link--target></a>
        </section>
    </article>
            <article class=syllabus__topic>
        <h4>Object-Oriented Programming, Part II</h4>
        <section class="syllabus__course color-scheme--white">
          <section class=syllabus__course__progress>
            <span class="syllabus__progress syllabus__progress--circle color-scheme--grey" value="0%"></span>
          </section>
          <section class=syllabus__course__description>
            <h5>Object-Oriented Programming II</h5>
            <div exclude=phone>
              <p>In this lesson, we'll cover more advanced aspects of OOP in Ruby, including information hiding, modules, and mixins.</p>
            </div>
          </section>
           <a href="/courses/50c246481de2b06e3e0072a1/resume?curriculum_id=5059f8619189a5000201fbcb" class=link--target></a>
        </section>
        <section class="syllabus__course color-scheme--white">
          <section class=syllabus__course__progress>
            <span class="syllabus__progress syllabus__progress--circle color-scheme--grey" value="0%"></span>
          </section>
          <section class=syllabus__course__description>
            <h5>Banking on Ruby</h5>
            <div exclude=phone>
              <p>Now that we know all about hiding information in Ruby, let's apply our new skills to write a program that can store, update, and display a bank account balance.</p>
            </div>
          </section>
           <a href="/courses/50d4bb7f625cae3813001b8b/resume?curriculum_id=5059f8619189a5000201fbcb" class=link--target></a>
        </section>
    </article>
        </section>
      </div>
    </article>
    <input type=hidden id=data-source value=conserv class=ui-inited>
    </main>
    <footer id=footer class=color-scheme--darkgrey>
      <div id=footer__main>
        <article class=fit-fixed>
          <div class="grid-row padding-top--half">
            <div class=grid-col-6>
              <img alt=Logo--grey class=margin-bottom--1 id=footer__logo src="http://cdn-production.codecademy.com/assets/logo/logo--grey-498acc77555893fa7740135d429f628e.svg">
              <p>Teaching the world how to code.</p>
              <div id=footer__company__links>
                <a href="/about">About Us</a>
                <a href="/jobs">We're hiring</a>
                <a href="/blog">Blog</a>
              </div>
            </div>
            <div class="grid-col-6 grid-row grid-col--no-margin">
              <div class="grid-col-4 grid-col--no-padding">
                <h5><strong>Learn To Code</strong></h5>
                <div><a href="/tracks/web">HTML &amp; CSS</a></div>
                <div><a href="/tracks/javascript">Javascript</a></div>
                <div><a href="/tracks/jquery">jQuery</a></div>
                <div><a href="/tracks/python">Python</a></div>
                <div><a href="/tracks/ruby">Ruby</a></div>
                <div><a href="/tracks/php">PHP</a></div>
                <div><a href="/tracks/apis">APIs</a></div>
              </div>
              <div class="grid-col-4 grid-col--no-padding">
                <h5><strong>Other Programs</strong></h5>
                <div><a href="/schools">Schools</a></div>
                <!--<div><a href="/enterprise">Enterprise</a></div>-->
                <div><a href="/stories">Stories</a></div>
                <div><a href="/teach">Teach</a></div>
              </div>
              <div class="grid-col-4 grid-col--no-padding">
                <h5><strong>Follow us</strong></h5>
                <div><a href="http://www.twitter.com/codecademy">Twitter</a></div>
                <div><a href="http://www.facebook.com/codecademy">Facebook</a></div>
                <div><a href="/blog">Blog</a></div>
              </div>
            </div>
          </div>
        </article>
      </div>
      <article id=footer__legal>
        <div class="grid-row fit-fixed">
          <div class="grid-col-6 grid-col--no-margin margin-top--none margin-bottom--none">
            <div id=footer__legal__links>
              <small>
                <a href="/help">Help</a>
                <a href="/policy">Privacy Policy</a>
                <a href="/terms">Terms</a>
              </small>
            </div>
          </div>
          <div class="grid-col-6 grid-col--no-margin grid-row margin-top--none margin-bottom--none">
            <div class="grid-col-7 grid-col--no-spacing">
              <div id=footer__legal__copyright>
                <small>
                  Made in NYC &#65533; 2014 Codecademy
                </small>
              </div>
            </div>
            <div id=footer__locale class="grid-col-5 grid-col--no-spacing margin-top-bottom--none grid-col--align-right">
              <div class="field field--select field-select--small field-select--transparent">
      <select class=locales id="">
              <option value="/en/tracks/ruby?locale_code=en" selected=selected>
                English
              </option>
              <option value="/en/tracks/ruby?locale_code=es">
                Espa&#65533;ol
              </option>
              <option value="/en/tracks/ruby?locale_code=fr">
                Fran&#65533;ais
              </option>
              <option value="/en/tracks/ruby?locale_code=pt-BR">
                Portugu&#65533;s (Brazil)
              </option>
              <option value="/en/tracks/ruby?locale_code=ky-KG">
                Kyrgyz (Kyrgyzstan)
              </option>
              <option value="/en/tracks/ruby?locale_code=fa">
                &#1601;&#1575;&#1585;&#1587;&#1740;
              </option>
      </select>
      <div class=field-select__down-arrow-icon>
        <span class="new-cc-icon icon--">downarrow</span>
      </div>
    </div>
            </div>
          </div>
        </div></article>
      
    </footer>
  eos
  }
)
 